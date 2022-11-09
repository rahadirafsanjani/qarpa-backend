class Audit < ApplicationRecord

  def self.filter_by params = {}
    return false unless params[:branch_id].present?

    conditions = {
      "branches": { 
        "id": params[:branch_id],
        "company_id": params[:company_id]    
      }
    }

    conditions.merge!(open_at: params[:date]) if params[:date].present?
    audits = Pos.includes(:branch)
                 .where(conditions)
    audits.map do |audit|
      {
        "id": audit.branch_id,
        "date": audit.open_at
      }
    end
  end
end
