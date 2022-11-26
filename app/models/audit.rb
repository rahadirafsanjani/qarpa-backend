class Audit < ApplicationRecord

  def self.expenses_incomes params = {}
    branch_id = Branch.where(company_id: params[:company_id]).ids
    expenses = Shipping.joins(
      "
      LEFT JOIN item_shippings ON item_shippings.shipping_id = shippings.id
      LEFT JOIN product_shareds ON product_shareds.id = item_shippings.product_shared_id
      "
    ).select(
      "
      shippings.id,
      (item_shippings.quantity * product_shareds.purchase_price) AS expenses 
      "
    ).group(
      "
      shippings.id,
      item_shippings.quantity,
      product_shareds.purchase_price
      "
    ).where(branch_id: branch_id)

    incomes = Pos.joins(
      "
      LEFT JOIN orders ON orders.pos_id = pos.id
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id
      LEFT JOIN product_shareds ON product_shareds.id = detail_orders.product_shared_id
      "
    ).select(
      "
      pos.id,
      (detail_orders.qty * product_shareds.selling_price) AS incomes
      "
    ).group(
      "
      pos.id,
      detail_orders.qty,
      product_shareds.selling_price
      "
    ).where(branch_id: branch_id)

    data = {}
    data[:incomes] = 0
    data[:expenses] = 0

    incomes.each do |income|
      data[:incomes] = data[:incomes] = (income.incomes || 0)
    end
    expenses.each do |expense|
      data[:expenses] = data[:expenses] + (expense.expenses || 0)
    end

    data
  end

  def self.get_reports params = {}
    date = params[:date].to_date 

    @beginning_of_day = date.beginning_of_day
    @end_of_day = date.end_of_day

    data = {}
    data.merge!(
      branch: get_branch_incomes(
        company_id: params[:company_id],
        date: @beginning_of_day..@end_of_day
      )
    )
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
      LEFT JOIN product_shareds ON product_shareds.id = detail_orders.product_shared_id
      "
    ).select(
      "
      branches.id,
      pos.open_at,
      pos.close_at,
      (SELECT users.name FROM users WHERE users.id = pos.user_id) AS user,
      SUM(detail_orders.qty) AS total_products,
      SUM(detail_orders.qty * product_shareds.selling_price) AS total_incomes
      "
    ).group(
      "branches.id",
      "pos.open_at", 
      "pos.close_at",
      "pos.user_id"
    ).where(conditions)

    branches.each do |branch|
      data << {
        "branch_id": branch.id,
        "user": branch.user,
        "open_at": branch.open_at,
        "close_at": branch.close_at,
        "total_products": branch.total_products,
        "total_incomes": branch.total_incomes
      }
    end

    return data
  end

  def self.time_formater time 
    time.strftime("%k:%M") if time.present?
  end

  def self.date_formater date 
    date.strftime("%d-%m-%Y") if date.present?
  end
end
