class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_one :rating, dependent: :destroy
  enum sex: {male: 0, female: 1}
  enum role: {user: 0, admin: 1}
end
