class Banking < ApplicationRecord
  has_many :payment_bankings, dependent: :destroy
end
