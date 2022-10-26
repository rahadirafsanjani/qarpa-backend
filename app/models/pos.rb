class Pos < ApplicationRecord
  before_create :search_branch, :open_pos
  belongs_to :branch

  validates :fund, :notes, :branch_id, presence: true
  validates :fund, numericality: { only_integer: true }

  private 

  def open_pos
    self.open_at = Time.now.utc 
    @branch.open_branch
  end

  def close_pos
    self.close_at = Time.now.utc 
    @branch.close_branch
  end

  def search_branch 
    @branch = Branch.find(self.branch_id)
    unless @branch.present?
      errors.add(:branch_id, "Branch not found")
      raise ActiveRecord::Rollback
    end
  end
end
