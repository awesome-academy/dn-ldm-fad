class ProductsController < ApplicationController
  def index
<<<<<<< HEAD
    @products = Product.product_display.sort_desc.paginate page: params[:page],
=======
    @products = Product.product_display.paginate page: params[:page],
>>>>>>> add product to cart
      per_page: Settings.product.paginate
  end
end
