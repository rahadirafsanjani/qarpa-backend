class Finance < ApplicationRecord

  def self.get_report params = {}
    @begining_of_day = ""
    @end_of_day = ""

    if params[:date].present?
      date = params[:date].to_date 
      @begining_of_day = date.beginning_of_day
      @end_of_day = date.end_of_day
    else
      date = Time.now.utc 
      @begining_of_day = date.beginning_of_day
      @end_of_day = date.end_of_day
    end

    conditions = {}
    conditions.merge!(:company_id => params[:company_id])
    conditions.merge!(:pos => {:created_at => @begining_of_day..@end_of_day})
    conditions.merge!(:id => params[:branch_id]) if params[:branch_id].present?

    reports = Branch.joins(
      "
      LEFT JOIN pos ON pos.branch_id = branches.id
      LEFT JOIN orders ON orders.pos_id = pos.id
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id
      LEFT JOIN products ON products.id = detail_orders.product_id
      "
    ).select(
      "
      branches.id,
      SUM(products.price) AS incomes,
      SUM(detail_orders.qty) AS total_products,
      COUNT(orders.id) AS total_transaction
      "
    ).group("branches.id").where(conditions)

    data = {}
    data[:incomes] = 0
    data[:total_products] = 0
    data[:total_transaction] = 0

    reports.each do |report|
      data[:incomes] = data[:incomes] + report.incomes
      data[:total_products] = data[:total_products] + report.total_products
      data[:total_transaction] = data[:total_transaction] + Order.where(pos_id: report.pos.ids).count
    end

    data
  end
end
