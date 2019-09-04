class Banking < ApplicationRecord
  has_many :payment_bankings, dependent: :destroy
  has_many :payments, through: :payment_bankings
end
