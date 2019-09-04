module CartsHelper
  def amount_product quantity, price
    quantity * price
  end

  def total_price carts, products
    products.reduce(0){|a, e| a + e.price * carts[e.id.to_s]}
  end
end
