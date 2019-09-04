class StaticPagesController < ApplicationController
  def home
    @products = Product.display.sort_desc.paginate page: params[:page],
      per_page: Settings.product.paginate
  end

  def about; end

  def contact; end

  def search
    key_replace = params[:search].tr " ", "%"
    @key_search = params[:search]
    @products = Product.display.by_name_price(key_replace,
      @key_search).paginate page: params[:page],
      per_page: Settings.product.paginate
  end
end
