class CartsController < ApplicationController
  before_action :load_cart_session, only: [:index, :add, :update]
  before_action :load_product, only: [:add, :update]

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
    redirect_to carts_path
  end

   def update
    @product_id = params[:product_id].to_i
    @carts[@product_id] = params[:quantity].to_i
    session[:carts] = @carts
    load_products
    total = total_price @carts, @products
    amount = amount_product params[:quantity].to_i, params[:price].to_i
    respond_to do |format|
      format.json {render json: { total: total, amount: amount}}
    end
  end

  def destroy
    remove_cart params[:id].to_i
    redirect_to carts_path
  end

  private

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product
    flash[:danger] = t "menu.product_not_found"
    redirect_to carts_path
  end

  def load_products
    @products = Product.by_ids @product_id
  end

  def load_cart_session
    session[:carts] ||= {}
    @carts = session[:carts]
  end
end
