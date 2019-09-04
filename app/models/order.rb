class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, approve: 1, delivering: 2, delivered: 3, cancel: 4}
  validates :customer, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  validates :phone, presence: true, numericality: {only_integer: true},
    length: {is: Settings.validates.maximum_phone}
  validates :address, presence: true,
    length: {maximum: Settings.validates.maximum_address}
  validates :status, presence: true, numericality: {only_integer: true}
  scope :by_customer_phone, (lambda do |search|
    where "customer LIKE (?) OR phone LIKE (?)", "%#{search}%", "%#{search}%"
  end)
end
