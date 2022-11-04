class LeaveManagement < ApplicationRecord
  belongs_to :user
  
  before_validation :validate_date_params
  validates :title, :notes, :start_at, :end_at, presence: true
  validate :date_validation

  enum :leave_status, { menunggu: 0, disetujui: 1, ditolak: 2 }, prefix: true

  def self.leave_response params = {}
    leave_managements = LeaveManagement.includes(:user).where(params).order('leave_managements.id DESC')
    leave_managements.map do |leave_management|
      leave_management.new_response
    end
  end
  
  def self.leave_response_employee params
    data = {}
    leave_status = LeaveManagement.group(:leave_status).where(user_id: params).count
    data[:menunggu] = leave_status['menunggu'] || 0
    data[:disetujui] = leave_status['disetujui'] || 0
    data[:ditolak] = leave_status['ditolak'] || 0
    
    data[:data] = LeaveManagement.where(user_id: params)
    
    return data
  end
  
  def action params
    data = false
    data = self.leave_status_disetujui! if params == 'disetujui'
    data = self.leave_status_ditolak! if params == 'ditolak'

    return data
  end
  
  def new_response
    {
        "id": self.id,
        "user_id": self.user_id,
        "name": self.user.name,
        "title": self.title,
        "notes": self.notes,
        "status": self.leave_status,
        "start_at": self.start_at,
        "end_at": self.end_at,
      }
  end
  
  private 

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
