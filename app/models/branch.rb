class Branch < ApplicationRecord
  validates :name, :fund, :notes, presence: true
  validates :fund, numericality: { only_integer: true }

  def close_branch()
    self.close_at = Time.now.utc
    self.status = false
    save!
  end

  def open_branch()
    self.open_at = Time.now.utc
    self.status = true
    save!
  end
end
