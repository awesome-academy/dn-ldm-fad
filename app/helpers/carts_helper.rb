module CartsHelper
  def amount_product quantity, price
    quantity * price
  end

  def total_price carts, products
    products.inject(0){|total, item| total += item.price*carts[item.id.to_s]}
  end
end
