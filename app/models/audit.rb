class Audit < ApplicationRecord

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
      
      conditions.merge!(:created_at => beginning_of_day..end_of_day) if params[:date].present?
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
    date.strftime("%d-%M-%Y") if date.present?
  end
end
