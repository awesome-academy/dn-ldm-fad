require "faker"

FactoryBot.define do
  factory :product do |f|
    f.name {Faker::Name.name}
    f.picture {"product-default.jpg"}
    f.price {100000}
    f.quantity {200}
    f.description {Faker::Lorem.sentence(10)}
    f.status {1}
    f.category_id {1}
    f.product_type_id {1}
  end
end
