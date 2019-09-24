class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  delegate :id, :name, :quantity, :picture, to: :product, prefix: :product
end
