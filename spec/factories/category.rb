require "faker"

FactoryBot.define do
  factory :category do |f|
    f.name {Faker::Name.name}
    f.description {Faker::Lorem.sentence(10)}
  end
end
