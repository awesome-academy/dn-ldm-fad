class PaymentBanking < ApplicationRecord
  belongs_to :payment
  belongs_to :banking
end
