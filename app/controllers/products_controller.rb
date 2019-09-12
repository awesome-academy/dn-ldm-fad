class ProductsController < ApplicationController
  before_action :load_product, only: :show

  def index
    @products = Product.display.sort_desc.paginate page: params[:page],
      per_page: Settings.product.paginate
  end

  def show; end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t "menu.product_not_found"
    redirect_to root_path
  end
end
