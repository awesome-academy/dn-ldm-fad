class OrdersController < ApplicationController
  authorize_resource
  before_action :load_cart_session, only: [:new, :create]
  before_action :load_products, only: :new
  after_action :remove_carts, only: :create

  def new
    @orders = Order.new
    @total_price = total_price @carts, @products
  end

  def create
    ActiveRecord::Base.transaction do
      order = @current_user.orders.create! order_params
      order.create_payment type_payment: params[:type_payment].to_i
      create_order_detail @carts, order
      minus_qty_product @carts, order.products
      send_order_mail current_user, @carts, order
      flash[:success] = t "order.order_success"
      redirect_to root_path
    end
  rescue StandardError
    flash[:danger] = t "order.order_fail"
    redirect_to root_path
  end

  private

  def order_params
    params.require(:order).permit :customer, :phone,
      :address, :total_price, :description
  end

  def load_products
    @products = Product.by_ids @carts.keys
    return if @products
    flash[:danger] = t "menu.product_not_found"
    redirect_to root_path
  end

  def create_order_detail carts, order
    carts.each do |product_id, quantity|
      price = Product.get_price product_id.to_i
      order.order_details.create! product_id: product_id, quantity: quantity,
        price: price
    end
  end

  def minus_qty_product carts, products
    products.each do |product|
      qty = product.quantity - carts[product.id.to_s]
      product.update_attribute :quantity, qty
    end
  end

  def send_order_mail user, carts, order
    OrderMailer.order_confirm(user, carts, order).deliver
  end

  def remove_carts
    session[:carts] = {}
  end
end
