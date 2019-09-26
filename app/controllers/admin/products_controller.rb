class Admin::ProductsController < Admin::AdminsController
  before_action :load_product, only: [:edit, :update, :destroy,
    :confirm_before_destroy]
  before_action :load_products, only: :index
  before_action :status_to_i, only: [:create, :update]
  before_action :check_order, only: [:destroy, :confirm_before_destroy]

  def index; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "admin.products.add_success"
      redirect_to admin_products_path
    else
      flash.now[:danger] = t "admin.products.add_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "admin.products.edit_success"
      redirect_to admin_products_path
    else
      flash.now[:danger] = t "admin.products.edit_fail"
      render :edit
    end
  end

  def destroy
    if @count.zero?
      if @waiting.zero?
        destroy_product
      else
        destroy_for_order_waiting
      end
    else
      flash[:danger] = t "admin.products.destroy_fail_count", count: @count
    end
    redirect_to admin_products_path
  end

  def confirm_before_destroy
    message = if @count.positive?
                t "admin.products.destroy_fail_count", count: @count
              elsif @count.zero? && @waiting.positive?
                t "admin.products.waiting", count: @waiting
              else
                t "cart.you_sure"
              end
    respond_to do |format|
      format.json{render json: {message: message}}
    end
  end

  def search
    key_replace = params[:search_product].tr " ", "%"
    @key_search = params[:search_product]
    @products = Product.display.by_name_price(key_replace,
      @key_search).paginate page: params[:page],
      per_page: Settings.product.paginate
    render :index
  end

  def load_categories
    categories = Category.sort_by_name.pluck :id, :name
    respond_to do |format|
      format.json{render json: {categories: categories}}
    end
  end

  def load_products_types
    product_types = ProductType.sort_by_name.pluck :id, :name
    respond_to do |format|
      format.json{render json: {product_types: product_types}}
    end
  end

  private

  def product_params
    params.require(:product).permit :name, :price, :quantity, :picture,
      :category_id, :product_type_id, :status, :description
  end

  def status_to_i
    return unless params[:product][:status]
    params[:product][:status] = params[:product][:status].to_i
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t "admin.orders.not_found"
    redirect_to admin_products_path
  end

  def load_products
    @products = Product.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.product.admin_paginate
  end

  def destroy_product
    if @product.destroy
      flash[:success] = t "admin.products.destroy_success"
    else
      flash[:danger] = t "admin.products.destroy_fail"
    end
  end

  def destroy_for_order_waiting
    ActiveRecord::Base.transaction do
      update_qty_product
      destroy_product
    end
  rescue StandardError
    flash[:danger] = t "admin.products.destroy_fail"
  end

  def check_order
    @count = 0
    @waiting = 0
    @order_waitings = []
    @product.orders.each do |order|
      @count += Settings.category.count if order.approve? || order.delivering?
      if order.waiting?
        @waiting += Settings.category.count
        @order_waitings.push order
      end
    end
  end

  def update_qty_product
    @order_waitings.each do |order|
      order.update_attributes status: :cancel
      order.order_details.each do |order_detail|
        product = order_detail.product
        next if product.id == @product.id
        qty_old = product.quantity
        qty_update = qty_old + order_detail.quantity
        product.update_attribute :quantity, qty_update
      end
    end
  end
end
