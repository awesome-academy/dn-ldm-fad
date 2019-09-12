class Payment < ApplicationRecord
  belongs_to :order
  has_many :payment_bankings, dependent: :destroy
  enum type_payment: {COD: 0, ATM: 1}
  validates :type_payment, presence: true
end
