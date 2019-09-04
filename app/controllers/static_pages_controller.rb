class StaticPagesController < ApplicationController
  def home
    @products = Product.product_display.sort_desc.paginate page: params[:page],
      per_page: Settings.product.paginate
  end

  def about; end

  def contact; end
end
