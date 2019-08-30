class Payment < ApplicationRecord
  belongs_to :order
  has_many :payment_bankings, dependent: :destroy
  has_many :bankings, throught: :payment_bankings
end
