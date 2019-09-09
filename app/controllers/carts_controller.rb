class CartsController < ApplicationController
  before_action :load_cart_session, only: [:index, :add]
  before_action :load_product, only: :add

  def index
    @products = Product.by_ids @carts.keys
    @total_price = total_price @carts, @products
  end

  def add
    if @carts.include? params[:product_id]
      @carts[params[:product_id]] += Settings.cart.qty_add
    else
      @carts[params[:product_id]] = Settings.cart.qty_add
    end
    session[:carts] = @carts
    flash[:success] = t "cart.add_cart_success"
    redirect_to cart_index_path
  end

  private

  def load_product
    product = Product.find_by id: params[:product_id]
    return if product
    flash[:danger] = t "menu.product_not_found"
    redirect_to cart_index_path
  end

  def load_cart_session
    session[:carts] ||= {}
    @carts = session[:carts]
  end
end
