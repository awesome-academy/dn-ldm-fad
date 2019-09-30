require "faker"

FactoryBot.define do
  factory :order do |f|
    f.customer {Faker::Name.name}
    f.phone {1105015016}
    f.address {Faker::Address.city}
    f.total_price {500000}
    f.description {Faker::Lorem.sentence(10)}
    f.status {1}
    f.user_id {1}
  end
end
