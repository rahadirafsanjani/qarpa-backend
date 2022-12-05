class Finance < ApplicationRecord

  def self.get_reports params = {}
    date = params[:date].present? ? params[:date].to_date : Time.now 
    
    @beginning_of_day = date.beginning_of_day
    @end_of_day = date.end_of_day 

    data = {}
    data.merge!(
      get_incomes(
        branch_id: params[:branch_id],
        company_id: params[:company_id],
        date: @beginning_of_day..@end_of_day
      )
    )
    data.merge!(
      get_expenses(
        branch_id: params[:branch_id],
        company_id: params[:company_id],
        date: @beginning_of_day..@end_of_day
      )
    )
  end

  def self.get_incomes params = {}
    conditions = {}
    conditions.merge!(:id => params[:branch_id]) if params[:branch_id].present?
    conditions.merge!(:branches => { :company_id => params[:company_id] })
    conditions.merge!(:pos => { :created_at => params[:date] })

    reports = Branch.joins(
      "
      LEFT JOIN pos ON pos.branch_id = branches.id 
      LEFT JOIN orders ON orders.pos_id = pos.id
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id 
      LEFT JOIN product_shareds ON product_shareds.id = detail_orders.product_shared_id 
      "
    ).select(
      "
      branches.id,
      SUM(detail_orders.qty) AS total_products,
      SUM(detail_orders.qty * product_shareds.selling_price) AS incomes,
      (SELECT COUNT(orders.id) FROM orders WHERE orders.pos_id = pos.id) AS total_transactions
      "
    ).group(
      "
      pos.id,
      branches.id
      "
    ).where(conditions)

    data = {}
    data[:total_transactions] = 0
    data[:incomes] = 0
    data[:total_products] = 0

    reports.each do |report|
      data[:incomes] += (report[:incomes] || 0)
      data[:total_products] += (report[:total_products] || 0)
      data[:total_transactions] += (report[:total_transactions] || 0)
    end

    data
  end

  def self.get_expenses params = {}
    conditions = {}
    conditions.merge!(:branch_id => params[:branch_id]) if params[:branch_id].present?
    conditions.merge!(:branches => {:company_id => params[:company_id]})
    conditions.merge!(:assign_at => params[:date])

    expenses = Shipping.joins(
      "
      LEFT JOIN branches ON branches.id = shippings.branch_id
      LEFT JOIN item_shippings ON item_shippings.shipping_id = shippings.id
      LEFT JOIN product_shareds ON product_shareds.id = item_shippings.product_shared_id
      "
    ).select(
      "
      branches.id,
      SUM(item_shippings.qty * product_shareds.purchase_price) AS total
      "
    ).group(
      "
      branches.id
      "
    ).where(conditions)
    
    data = {}
    data[:expenses] = 0
    
    expenses.map do |expense|
      data[:expenses] = data[:expenses] + (expense.total || 0)
    end

    return data
  end
end

