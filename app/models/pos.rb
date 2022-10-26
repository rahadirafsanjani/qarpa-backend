class Pos < ApplicationRecord
  before_create :open_pos
  belongs_to :branch

  validates :fund, :notes, :branch_id, presence: true
  validates :fund, numericality: { only_integer: true }

  def open_pos
    self.open_at = Time.now.utc
    branch = search_branch  
    branch.open_branch
  end

  def close_pos
    self.close_at = Time.now.utc
    save!(validate: false) 
    branch = search_branch
    branch.close_branch
  end

  private

  def search_branch 
    branch = Branch.find(self.branch_id)
    unless branch.present?
      errors.add(:branch_id, "Branch not found")
      raise ActiveRecord::Rollback
    end
    return branch
  end
end
