module CartsHelper
  def add_cart product_id
    load_cart_session
    load_product product_id
    if @carts.include? product_id
      @carts[product_id] += 1
    elsif
      @carts[product_id] = 1
    end
    session[:carts] = @carts
  end

  def load_product product_id
    product = Product.find_by id: product_id.to_i
    return if product
    flash[:danger] = t "menu.product_not_found"
    redirect_to cart_index_path
  end

  def load_cart_session
    @carts = session[:carts] ||= {}
  end

  def amount_product quantity, price
    quantity*price
  end

  def total_price carts, products
    total = 0
    products.each do |item|
      total += item.price*carts[item.id.to_s]
    end
    total
  end
end
