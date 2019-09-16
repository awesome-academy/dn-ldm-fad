class Product < ApplicationRecord
  belongs_to :category
  belongs_to :product_type
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  delegate :name, to: :category, prefix: :category
  enum status: {hide: 0, display: 1}
  scope :sort_desc, ->{order created_at: :desc}
  scope :by_ids, ->(ids){where id: ids}
  scope :get_price, ->(id){where(id: id).pluck(:price).first}
  scope :by_name_price, (lambda do |name_product, price|
    where "name LIKE (?) OR price <= (?)", "%#{name_product}%", price
  end)
end
