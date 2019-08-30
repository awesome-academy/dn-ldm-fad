class Product < ApplicationRecord
  belongs_to :category
  belongs_to :product_type
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  enum status: {hide: 0, display: 1}
end
