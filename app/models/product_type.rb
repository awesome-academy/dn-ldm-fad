class ProductType < ApplicationRecord
  has_many :products, dependent: :destroy
end
