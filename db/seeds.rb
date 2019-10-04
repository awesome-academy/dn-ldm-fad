User.create!(name:  "Lê Đức Mạnh",
             email: "leducmanh101198@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             birthday: "10/11/1998",
             sex: 0,
             phone: "0356796738",
             address: "Hòa Hải, Ngũ Hành Sơn, Đà Nẵng",
             role: 1)

2.times do |n|
  category = Category.create!(name: "Category#{n+1}",
  description: Faker::Lorem.sentence(10))

  product_type = ProductType.create!(name: "ProductType#{n+1}",
  description: Faker::Lorem.sentence(10))

  5.times do |m|
    product = Product.create!(name: "Product#{m+1}",
                              picture: "product#{m}.jpg",
                              price: rand(100000..500000),
                              quantity: rand(50..200),
                              description: Faker::Lorem.sentence(10),
                              status: 1,
                              category_id: category.id,
                              product_type_id: product_type.id)

  end
end
