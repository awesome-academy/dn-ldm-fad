class CartsController < ApplicationController

  def index
    carts = load_cart_session
    @products = Product.find_collection_id carts.keys
    @total_price = total_price carts, @products
  end

  def add
    add_cart params[:product_id]
    flash[:success] = t "cart.add_cart_success"
    redirect_to cart_index_path
  end
end
