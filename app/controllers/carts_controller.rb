class CartsController < ApplicationController
  before_action :load_cart_session, except: [:new, :show, :edit]
  before_action :load_products, only: :update
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
    @carts[params[:product_id]] = params[:quantity].to_i
    total = total_price @carts, @products
    amount = amount_product params[:quantity].to_i, params[:price].to_i
    respond_to do |format|
      format.json{render json: {total: total, amount: amount}}
    end
  end

  def destroy
    product_id = params[:id].to_s
    if @carts.include? product_id
      @carts.delete product_id
      flash[:success] = t "cart.remove_success"
    else
      flash[:danger] = t "cart.remove_fail"
    end
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
    @products = Product.by_ids @carts.keys
  end

  def load_cart_session
    session[:carts] ||= {}
    @carts = session[:carts]
  end
end
