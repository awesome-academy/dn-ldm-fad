class ProductsController < ApplicationController
  before_action :load_rating, only: :destroy_rating
  before_action :load_product, :load_one_star, :load_two_star, :load_three_star,
    :load_four_star, :load_five_star, :load_sum_star, :load_avt_star,
    only: :show

  def index
    @products = Product.display.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.product.paginate
  end

  def show
    @ratings = Rating.product_ratings params[:id]
    @rating = Rating.new
  end

  def rating_product
    rating = current_user.ratings.create rating_params
    if rating.save
      flash[:success] = t "detail.cmt_success"
    else
      flash[:danger] = t "detail.cmt_fail"
    end
    redirect_to product_path params[:id]
  end

  def destroy_rating
    if @rating.destroy
      flash[:success] = t "detail.destroy_rating_success"
    else
      flash[:danger] = t "detail.destroy_rating_fail"
    end
    redirect_to product_path(@rating.product_id)
  end

  private

  def load_one_star
    @one_star = @product.ratings.very_bad.count_star
  end

  def load_two_star
    @two_star = @product.ratings.bad.count_star
  end

  def load_three_star
    @three_star = @product.ratings.medium.count_star
  end

  def load_four_star
    @four_star = @product.ratings.good.count_star
  end

  def load_five_star
    @five_star = @product.ratings.excellent.count_star
  end

  def load_sum_star
    @sum_star = @product.ratings.count_star
  end

  def load_avt_star
    return @avg_star = Settings.avg.value_default if @sum_star.zero?
    @avg_star = @product.ratings.avg_star
    @avg_star = @avg_star.round(Settings.avg.round)
  end

  def load_rating
    @rating = Rating.find_by id: params[:id]
    return if @rating
    flash[:warning] = t "detail.rating_not_found"
    redirect_to root_path
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:warning] = t "detail.product_not_found"
    redirect_to root_path
  end

  def rating_params
    star_to_i if params[:rating][:star]
    params.require(:rating).permit :star, :comment, :product_id
  end

  def star_to_i
    params[:rating][:star] = params[:rating][:star].to_i
  end
end
