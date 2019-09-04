class CartsController < ApplicationController
  before_action :load_cart_session, except: [:new, :show, :edit]
  before_action :load_products, only: :update
  before_action :load_product, only: [:add, :update]

  def index; end

  def add
    product_key = params[:product_id]
    @status = true
    if @carts.include? product_key
      @carts[product_key] += Settings.cart.qty_add
      @message = t "cart.update_cart_up_qty"
      @status = false
    else
      @carts[product_key] = Settings.cart.qty_add
      @message = t "cart.add_cart_success"
    end
    @amount = amount_product @carts[product_key], @product.price
    respond_to_data_cart
  end

  def update
    quantity = params[:quantity].to_i
    if !quantity.positive?
      msg = {status: "fail"}
    elsif quantity > @product.quantity
      msg = {status: "not_enough"}
    else
      @carts[params[:product_id]] = quantity
      total = total_price @carts, @products
      amount = amount_product quantity, params[:price].to_i
      msg = {total: total, amount: amount}
    end
    respond_to do |format|
      format.json{render json: msg}
    end
  end

  def destroy
    @product_id = params[:id].to_s
    @status = true
    if @carts.include? @product_id
      @carts.delete @product_id
      @message = t "cart.remove_success"
    else
      @message = t "cart.remove_fail"
      @status = false
    end
    respond_to_data_cart
  end

  private

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product
    flash[:danger] = t "menu.product_not_found"
    redirect_to carts_path
  end

  def load_products
    @products = Product.by_ids @carts.keys
  end

  def respond_to_data_cart
    session[:carts] = @carts
    @total = total_price @carts, load_products
    respond_to do |format|
      format.html{redirect_to root_path}
      format.js {}
    end
  end
end
