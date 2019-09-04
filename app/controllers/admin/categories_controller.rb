class Admin::CategoriesController < Admin::AdminsController
  before_action :load_categories, only: [:index, :create]
  before_action :load_category, only: [:edit, :update, :destroy,
    :confirm_before_destroy]
  before_action :check_product_order, only: [:destroy, :confirm_before_destroy]

  def index
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "admin.categories.add_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "admin.categories.add_fail"
      render :index
    end
  end

  def edit; end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "admin.categories.update_success"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t "admin.categories.update_fail"
      render :edit
    end
  end

  def destroy
    if @count.zero?
      if @waiting.zero?
        destroy_category
      else
        destroy_for_order_waiting
      end
    else
      flash[:danger] = t "admin.categories.destroy_fail_count", count: @count
    end
    redirect_to admin_categories_path
  end

  def confirm_before_destroy
    message = if @count.positive?
                t "admin.categories.destroy_fail_count", count: @count
              elsif @count.zero? && @waiting.positive?
                t "admin.categories.waiting", count: @waiting
              else
                t "admin.categories.you_sure"
              end
    respond_to do |format|
      format.json{render json: {message: message}}
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :description
  end

  def load_categories
    @categories = Category.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.user.paginate
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = "categories.not_found"
    redirect_to admin_categories_path
  end

  def destroy_category
    if @category.destroy
      flash[:success] = t "admin.categories.destroy_success"
    else
      flash[:danger] = t "admin.categories.destroy_fail"
    end
  end

  def destroy_for_order_waiting
    ActiveRecord::Base.transaction do
      update_qty_product
      destroy_category
    end
  rescue StandardError
    flash[:danger] = t "admin.products.destroy_fail"
  end

  def check_product_order
    @count = 0
    @waiting = 0
    @order_waitings = []
    @category.products.each do |product|
      product.orders.each do |order|
        @count += Settings.category.count if order.approve? || order.delivering?
        if order.waiting?
          @waiting += Settings.category.count
          @order_waitings.push order
        end
      end
    end
  end

  def update_qty_product
    @order_waitings.each do |order|
      order.update_attributes status: :cancel
      order.order_details.each do |order_detail|
        product = order_detail.product
        next if product.category_id == @category.id
        qty_old = product.quantity
        qty_update = qty_old + order_detail.quantity
        product.update_attribute :quantity, qty_update
      end
    end
  end
end
