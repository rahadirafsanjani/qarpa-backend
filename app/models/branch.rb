class Branch < ApplicationRecord
  attr_accessor :full_address
  before_validation :validate_address, :create_address
  
  belongs_to :address 
  belongs_to :company
  has_many :pos, class_name: "Pos", foreign_key: "branch_id"
  has_many :users
  has_many :products, as: :parent

  validates :name, :phone, presence: true

  def self.get_dropdown params = {}
    branches = Branch.where(params)
    branches.map do |branch|
      {
        "id": branch.id,
        "name": branch.name
      }
    end
  end

  def self.get_all_branch params = {} 
    branches = Branch.joins(
      "
      LEFT JOIN addresses ON addresses.id = branches.address_id
      LEFT JOIN pos ON pos.branch_id = branches.id
      LEFT JOIN orders ON orders.pos_id = pos.id
      LEFT JOIN detail_orders ON detail_orders.order_id = orders.id
      LEFT JOIN products ON products.id = detail_orders.product_id
      "
    ).select(
      "
      branches.id,
      branches.name,
      branches.company_id,
      branches.phone, 
      branches.status,
      addresses.full_address AS addresses,
      COUNT(orders.id) AS total_orders,
      SUM(products.price) AS total_incomes
      "
    ).group(
      "
      branches.id,
      branches.name,
      branches.company_id,
      branches.phone,
      branches.status,
      addresses.full_address
      "
    ).where(params)

    branches.map do |branch|
      branch.new_response.merge!(
        address: branch.addresses,
        total_orders: Order.where(pos_id: branch.pos.ids).count,
        total_incomes: branch.total_incomes.nil? ? 0 : branch.total_incomes
      )
    end
  end

  def new_response 
    {
      "id": self.id,
      "company_id": self.company_id,
      "name": self.name,
      "status": self.status,
      "phone": self.phone
    }
  end

  def open_branch 
    self.status = true 
    save!(validate: false)
  end

  def close_branch
    self.status = false
    self.save!(validate: false)
  end

  private

  def validate_address 
    errors.add(:full_address, "Full address cannot be blank") if self.full_address.blank?
    raise ActiveRecord::Rollback if self.full_address.blank?
  end

  def create_address
    address = Address.find_or_create_by(full_address: self.full_address)
    self.address_id = address.id
  end
end
