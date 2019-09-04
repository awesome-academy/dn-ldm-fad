class Admin::OrdersController < Admin::AdminsController
  before_action :load_order, only: [:show, :update, :destroy]
  before_action :status_to_i, only: :update

  def index
    @orders = Order.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.order.admin_paginate
  end

  def show
    @order_details = @order.order_details
  end

  def update
    ActiveRecord::Base.transaction do
      @order.update_attributes order_params
      update_qty_product if @order.cancel?
      flash[:success] = t "admin.orders.update_success"
      redirect_to admin_orders_path
    end
  rescue StandardError
    flash[:danger] = t "admin.orders.update_fail"
    redirect_to admin_orders_path
  end

  def search
    key_replace = params[:search_order].tr " ", "%"
    @orders = Order.by_customer_phone(key_replace).paginate page: params[:page],
      per_page: Settings.order.admin_paginate
    render :index
  end

  def filter_by_status
    @orders = if params[:status].present?
                Order.by_status(params[:status]).sort_by_created_at
                     .paginate page: params[:page],
                       per_page: Settings.order.admin_paginate
              else
                Order.sort_by_created_at.paginate page: params[:page],
                  per_page: Settings.order.admin_paginate
              end
    respond_to_data_order
  end

  private

  def order_params
    params.require(:order).permit :status
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "admin.orders.not_found"
    redirect_to admin_orders_path
  end

  def status_to_i
    return unless params[:order][:status]
    params[:order][:status] = params[:order][:status].to_i
  end

  def update_qty_product
    @order.order_details.each do |order_detail|
      product = order_detail.product
      qty_old = product.quantity
      qty_update = qty_old + order_detail.quantity
      product.update_attribute :quantity, qty_update
    end
  end

  def respond_to_data_order
    respond_to do |format|
      format.json{render json: {orders: @orders}}
    end
  end
end
