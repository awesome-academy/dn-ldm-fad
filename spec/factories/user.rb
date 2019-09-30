require "faker"

FactoryBot.define do
  factory :user do |f|
    f.name {Faker::Name.name}
    f.email {Faker::Internet.email}
    f.password {"123456"}
    f.password_confirmation {"123456"}
    f.phone {1234567891}
    f.address {Faker::Address.city}
  end
end
