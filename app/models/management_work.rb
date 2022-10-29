class ManagementWork < ApplicationRecord
  belongs_to :user

  before_validation :validate_date_params
  validates :task, :description, presence: true
  validate :date_validation

  enum :status, { todo: 0, done: 1 }

  def self.task_response params = {}
    management_works = ManagementWork.includes(:user).where(params).order('id DESC')
    management_works.map do |work|
      work.new_response
    end
  end

  def new_response
    {
        "id": self.id,
        "user_id": self.user_id,
        "name": self.user.name,
        "task": self.task,
        "description": self.description,
        "status": self.status,
        "start_at": self.start_at,
        "end_at": self.end_at,
        "number_of_days": (self.end_at - self.start_at).to_i
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
