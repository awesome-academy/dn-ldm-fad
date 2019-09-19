class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :name, presence: true,
    length: {maximum: Settings.validates.maximum_name_cate},
    uniqueness: {case_sensitive: false}
end
