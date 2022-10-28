class ManagementWork < ApplicationRecord
  belongs_to :user

  before_validation :validate_date_params
  validates :task, :description, presence: true
  validate :date_validation

  enum :status, { todo: 0, done: 1 }

  def self.task_response params = {}
    management_works = ManagementWork.includes(:user).where(params).order('id DESC')
    management_works.map do |work|
      new_response(work)
    end
  end

  def self.show_task params = {}
    management_work = ManagementWork.find_by(params)
    return false if management_work.blank?
    new_response(management_work)
  end
  
  private 

  def self.new_response(work)
    {
        "id": work.id,
        "user_id": work.user_id,
        "name": work.user.name,
        "task": work.task,
        "description": work.description,
        "status": work.status,
        "start_at": work.start_at,
        "end_at": work.end_at,
        "number_of_days": (work.end_at - work.start_at).to_i
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
