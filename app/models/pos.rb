class Pos < ApplicationRecord
  before_create :open_pos
  belongs_to :branch
  has_many :orders

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

  def new_response
    {
      "pos_id": self.id,
      "branch_id": self.branch_id,
      "user_id": self.user_id, 
      "fund": self.fund,
      "notes": self.notes,
      "open_at": self.open_at,
      "close_at": self.close_at,
      "created_at": self.created_at,
      "updated_at": self.updated_at
    }
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
