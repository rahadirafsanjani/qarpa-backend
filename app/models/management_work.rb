class ManagementWork < ApplicationRecord
  belongs_to :user

  before_validation :validate_date_params
  validates :task, :description, presence: true
  validate :date_validation

  enum :status, { todo: 0, done: 1 }

  private 

  def validate_date_params 
    errors.add(:start_at, "Start at cannot be blank") if self.start_at.blank?
    errors.add(:end_at, "End at cannot be blank") if self.end_at.blank?
  end

  def date_validation 
    unless self.start_at.blank? && self.end_at.blank?
      errors.add(:start_at, "Start at cannot bigger than end at") if self.start_at > self.end_at
    end
  end
end
