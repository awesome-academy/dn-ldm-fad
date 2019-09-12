class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, approve: 1, delivering: 3, delivered: 4, cancel: 5}
  validates :customer, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  validates :phone, presence: true,
    length: {maximum: Settings.validates.maximum_phone}
  validates :address, presence: true,
    length: {maximum: Settings.validates.maximum_address}
end
