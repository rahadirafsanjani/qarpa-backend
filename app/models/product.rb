class Product < ApplicationRecord
  belongs_to :supplier
  belongs_to :inventory
  has_many :detail_order
  has_many :orders, through: :detail_order
  # image
  has_one_attached :image, :dependent => :destroy
  validate :acceptable_image
  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  private
  def acceptable_image
    unless image.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end
