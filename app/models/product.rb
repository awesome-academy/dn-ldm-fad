class Product < ApplicationRecord
  belongs_to :category
  belongs_to :product_type
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  delegate :name, to: :category, prefix: :category
  enum status: {hide: 0, display: 1}
  scope :product_display, ->{where status: :display}
  scope :sort_desc, ->{order created_at: :desc}
end
