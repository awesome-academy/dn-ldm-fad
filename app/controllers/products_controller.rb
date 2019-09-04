class ProductsController < ApplicationController
  def index
    @products = Product.display.sort_desc.paginate page: params[:page],
      per_page: Settings.product.paginate
  end
end
