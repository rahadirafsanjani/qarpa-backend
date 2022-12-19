class Audit < ApplicationRecord

  def self.expenses_incomes params = {}
    date = Time.now 

    @beginning_of_week = date.beginning_of_week
    @end_of_week = date.end_of_week

    incomes = Branch.joins(
      "
      LEFT JOIN pos ON pos.branch_id = branches.id
      LEFT JOIN orders ON orders.pos_id = pos.id
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id
      LEFT JOIN products_branches ON products_branches.id = detail_orders.products_branch_id
      "
    ).select(
      "
      orders.discount,
      SUM(detail_orders.qty * products_branches.selling_price) AS total_incomes
      "
    ).group(
      "
      orders.discount
      "
    ).where(
      company_id: params[:company_id],
      pos: {
        created_at: @beginning_of_week..@end_of_week
      }
    )

    expenses = Branch.joins(
      "
      LEFT JOIN products_branches ON products_branches.branch_id = branches.id
      LEFT JOIN products_quantities ON products_quantities.products_branch_id = products_branches.id
      "
    ).select(
      "
      SUM(products_branches.purchase_price * products_quantities.qty) AS total_expenses
      "
    ).where(
      company_id: params[:company_id],
      products_quantities: { 
        created_at: @beginning_of_week..@end_of_week,
        qty_type: 0 
      }
    )

    data = {}
    data[:incomes] = 0
    data[:expenses] = 0

    incomes.each do |income| 
      data[:incomes] = data[:incomes] + (income.total_incomes || 0) - (income.discount || 0)
    end

    expenses.each do |expense| 
      data[:expenses] = data[:expenses] + (expense.total_expenses || 0)
    end

    data
  end

  def self.get_reports params = {}
    date = params[:date].to_date 

    @beginning_of_day = date.beginning_of_day
    @end_of_day = date.end_of_day

    incomes = get_branch_incomes(
      company_id: params[:company_id],
      date: @beginning_of_day..@end_of_day
    )

    expenses = get_expenses(
      company_id: params[:company_id],
      date: @beginning_of_day..@end_of_day
    )

    shippings = get_total_shippings(
      company_id: params[:company_id],
      date: @beginning_of_day..@end_of_day
    )

    total_incomes = 0
    
    incomes.each do |income|
      total_incomes = total_incomes + (income[:total_transaction_incomes] || 0)
    end

    data = {}
    data.merge!(branch: incomes)
    data.merge!(total_incomes: total_incomes)
    data.merge!(total_shipment_branch: shippings)
    data.merge!(total_profit: total_incomes - expenses[:total_expenses])
    data.merge!(expenses)
  end

  def self.get_branch_incomes params = {} 
    data = []
    conditions = {}
    conditions.merge!(:company_id => params[:company_id])
    conditions.merge!(:pos => {
      open_at: params[:date]
    })

    branches = Branch.joins(
      "
      LEFT JOIN pos ON pos.branch_id = branches.id
      LEFT JOIN orders ON orders.pos_id = pos.id
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id 
      LEFT JOIN products_branches ON products_branches.id = detail_orders.products_branch_id
      "
    ).select(
      "
      branches.id,
      branches.name,
      pos.open_at,
      pos.close_at,
      orders.discount,
      (SELECT users.name FROM users WHERE users.id = pos.user_id) AS user,
      SUM(detail_orders.qty) AS total_products,
      SUM(detail_orders.qty * products_branches.selling_price) AS total_incomes
      "
    ).group(
      "
      branches.id,
      branches.name,
      orders.discount,
      pos.open_at,
      pos.close_at,
      pos.user_id
      "
    ).where(conditions)

    branches.each do |branch|
      data << {
        "branch_id": branch.id,
        "branch_name": branch.name,
        "user": branch.user,
        "open_at": time_formater(branch.open_at),
        "close_at": time_formater(branch.close_at),
        "total_sold_product": branch.total_products,
        "total_transaction_incomes": (branch.total_incomes || 0) - (branch.discount || 0)
      }
    end

    return data
  end

  def self.get_expenses params = {} 
    data = {}
    data[:total_expenses] = 0
    data[:total_purchased_products] = 0

    conditions = {}
    conditions.merge!(:company_id => params[:company_id])
    conditions.merge!(:products_quantities => { :created_at => params[:date], :qty_type => 0})

    expenses = Branch.joins(
      "
      LEFT JOIN products_branches ON products_branches.branch_id = branches.id 
      LEFT JOIN products_quantities ON products_quantities.products_branch_id = products_branches.id
      "
    ).select(
      "
      SUM(products_quantities.qty) AS total_products,
      SUM(products_branches.purchase_price * products_quantities.qty) AS expenses
      "
    ).where(conditions)

    expenses.each do |expense|
      data[:total_expenses] = data[:total_expenses] + (expense.expenses || 0)
      data[:total_purchased_products] = data[:total_purchased_products] + (expense.total_products || 0)
    end



    data
  end

  def self.get_total_shippings params = {}
    shippings = Branch.joins(
      "
      LEFT JOIN shippings ON shippings.destination_id = branches.id
      "
    ).where(
      :shippings => { :assign_at => params[:date] },
      :company_id => params[:company_id]
    ).count

    shippings
  end

  def self.time_formater time = ""
    time.to_fs(:time) if time.present?
  end

  def self.date_formater date 
    date.strftime("%d-%m-%Y") if date.present?
  end
end
