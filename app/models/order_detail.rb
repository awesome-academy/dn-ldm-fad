class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  delegate :id, :name, :quantity, :picture, to: :product, prefix: :product
  scope :hot_product, (lambda do
    where("EXTRACT(MONTH FROM created_at) = ?",
      Time.zone.now.month).group(:product_id).order("SUM(quantity) DESC")
                                             .select(:product_id)
                                             .limit(Settings.product.hot_limit)
  end)
end
