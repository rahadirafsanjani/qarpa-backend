class Finance < ApplicationRecord

  def self.get_report params = {}
    @begining_of_day = ""
    @end_of_day = ""

    if params[:date].present?
      date = params[:date].to_date 
      @begining_of_day = date.beginning_of_day
      @end_of_day = date.end_of_day
    else
      date = Time.now
      @begining_of_day = date.beginning_of_day
      @end_of_day = date.end_of_day
    end

    conditions = {}
    conditions.merge!(:company_id => params[:company_id])
    conditions.merge!(:pos => {:created_at => @begining_of_day..@end_of_day})
    conditions.merge!(:id => params[:branch_id]) if params[:branch_id].present?

    transactions = Branch.joins(
      "
      LEFT JOIN pos ON pos.branch_id = branches.id
      LEFT JOIN orders ON orders.pos_id = pos.id
      "
    ).select(
      "
      branches.id,
      COUNT(orders.id) AS total_transaction
      "
    ).group(
      "
      branches.id
      "
    ).where(conditions)

    
    data = {}
    data.merge!(
      get_incomes_total_products(
        company_id: params[:company_id],
        branch_id: params[:branch_id], 
        date: @begining_of_day..@end_of_day
      )
    )
    data.merge!(
      get_expenses(
        company_id: params[:company_id],
        branch_id: params[:branch_id],
        date: @begining_of_day..@end_of_day
      )
    )
    data[:total_transaction] = 0

    transactions.each do |transaction|
      data[:total_transaction] = data[:total_transaction] + transaction.total_transaction
    end

    data
  end

  def self.get_incomes_total_products params = {}
    conditions = {}
    conditions.merge!(:branch_id => params[:branch_id]) if params[:branch_id].present?
    conditions.merge!(:branch => {:company_id => params[:company_id]})
    conditions.merge!(:created_at => params[:date])

    pos_id = Pos.includes(:branch).where(conditions).pluck(:id)
    
    reports = Order.joins(
      "
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id 
      LEFT JOIN products ON products.id = detail_orders.product_id  
      "
    ).select(
      "
      detail_orders.id,
      SUM(detail_orders.qty) AS total_products,
      (detail_orders.qty * products.price) AS incomes
      "
    ).group(
      "
      detail_orders.id,
      detail_orders.qty,
      products.price
      "
    ).where(pos_id: pos_id)

    data = {}
    data[:incomes] = 0
    data[:total_products] = 0

    reports.each do |report|
      data[:incomes] = data[:incomes] + (report.incomes || 0)
      data[:total_products] = data[:total_products] + (report.total_products || 0)
    end

    return data
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
      LEFT JOIN products ON products.id = item_shippings.product_id
      "
    ).select(
      "
      item_shippings.id,
      item_shippings.quantity, 
      products.price AS harga,
      (item_shippings.quantity * products.price) AS total
      "
    ).group(
      "
      item_shippings.id,
      item_shippings.quantity,
      products.price
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
