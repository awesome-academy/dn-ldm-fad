class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_one :payment, dependent: :destroy
  enum status: {waiting: 0, approve: 1, delivering: 3, delivered: 4, cancel: 5}
end
