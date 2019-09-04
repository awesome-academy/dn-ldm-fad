module CartsHelper
  def remove_cart product_id
    load_cart_session
    if @carts.include? product_id.to_s
      @carts.delete product_id.to_s
      flash[:success] = t "cart.remove_success"
    else
      flash[:danger] = t "cart.remove_fail"
    end
  end

  def amount_product quantity, price
    quantity * price
  end

  def total_price carts, products
    products.inject(0){|total, item| total += item.price*carts[item.id.to_s]}
  end
end
