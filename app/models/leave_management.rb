class LeaveManagement < ApplicationRecord
  belongs_to :user
  
  before_validation :validate_date_params
  validates :title, :notes, :start_at, :end_at, presence: true
  validate :date_validation

  enum :leave_status, { waiting: 0, approved: 1, reject: 2 }, prefix: true

  def self.leave_response params = {}
    leave_managements = LeaveManagement.includes(:user).where(params).order('id DESC')
    leave_managements.map do |leave_management|
      new_response(leave_management)
    end
  end

  def action params
    data = false
    data = self.leave_status_approved! if params == 'approved'
    data = self.leave_status_reject! if params == 'reject'
    
    return data
  end
  
  private 

  def self.new_response(leave)
    {
        "id": leave.id,
        "user_id": leave.user_id,
        "name": leave.user.name,
        "title": leave.title,
        "notes": leave.notes,
        "status": leave.leave_status,
        "start_at": leave.start_at,
        "end_at": leave.end_at,
      }
  end

  def validate_date_params 
    errors.add(:start_at, "Start at cannot be blank") if self.start_at.blank?
    errors.add(:end_at, "End at cannot be blank") if self.end_at.blank?
  end

  def date_validation 
    unless self.start_at.blank? || self.end_at.blank?
      errors.add(:start_at, "Start at cannot bigger than end at") if self.start_at > self.end_at
    end
  end
end
