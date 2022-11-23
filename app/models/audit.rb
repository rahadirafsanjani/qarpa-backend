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

  def self.filter_by params = {}
    return false unless params[:branch_id].present?
    
    conditions = {
      "branches": { 
        "id": params[:branch_id],
        "company_id": params[:company_id]    
      }
    }

    if params[:date].present? 
      date = params[:date].to_date
      
      beginning_of_day = date.beginning_of_day
      end_of_day = date.end_of_day
      
      conditions.merge!(:created_at => beginning_of_day..end_of_day)
    end
    
    audits = Pos.includes(:branch)
                 .where(conditions)
    audits.map do |audit|
      {
        "id": audit.branch_id,
        "date": date_formater(audit.open_at),
        "open_at": time_formater(audit.open_at),
        "close_at": time_formater(audit.close_at)
      }
    end
  end

  def self.time_formater time 
    time.strftime("%k:%M") if time.present?
  end

  def self.date_formater date 
    date.strftime("%d-%m-%Y") if date.present?
  end
end
