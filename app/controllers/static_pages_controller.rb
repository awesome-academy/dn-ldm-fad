class StaticPagesController < ApplicationController
  def home
    @products = Product.displayed.sort_desc.paginate page: params[:page],
      per_page: Settings.product.paginate
    @hot_order_details = OrderDetail.hot_product
  end

  def about; end

  def contact; end

  def search
    @key_search = params[:q][:by_name_cate_type_cont]
    @products = @q.result.includes(:category, :product_type)
                  .displayed.sort_by_created_at
                  .paginate page: params[:page],
                    per_page: Settings.product.paginate
  end
end
