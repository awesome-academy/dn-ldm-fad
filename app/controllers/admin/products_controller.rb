class Admin::ProductsController < Admin::AdminsController
  before_action :load_category_product_type, only: [:new, :edit]
  before_action :load_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.product.admin_paginate
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "admin.products.add_success"
      redirect_to admin_products_path
    else
      load_category_product_type
      flash.now[:danger] = t "admin.products.add_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "admin.products.edit_success"
    else
      flash[:danger] = t "admin.products.edit_fail"
    end
    redirect_to admin_products_path
  end

  def destroy
    if @product.destroy
      flash[:success] = t "admin.products.destroy_success"
    else
      flash[:danger] = t "admin.products.destroy_fail"
    end
    redirect_to admin_products_path
  end

  def search
    key_replace = params[:search_product].tr " ", "%"
    @key_search = params[:search_product]
    @products = Product.product_display.by_name_price(key_replace,
      @key_search).paginate page: params[:page],
      per_page: Settings.product.paginate
    render :index
  end

  private

  def load_category_product_type
    @categorys = Category.all
    @product_types = ProductType.all
  end

  def product_params
    status_to_i if params[:product][:status]
    params.require(:product).permit :name, :price, :quantity, :picture,
      :category_id, :product_type_id, :status, :description
  end

  def status_to_i
    params[:product][:status] = params[:product][:status].to_i
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t "admin.products.not_found"
    redirect_to admin_products_path
  end
end
