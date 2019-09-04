class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :product
  enum star: {default: 0, very_bad: 1, bad: 2, medium: 3, good: 4, excellent: 5}
  delegate :name, :picture, to: :user, prefix: :user
  delegate :id, to: :product, prefix: :product
  scope :product_ratings, ->(id){where product_id: id}
  scope :count_star, ->{count :star}
  scope :avg_star, ->{average :star}
end
