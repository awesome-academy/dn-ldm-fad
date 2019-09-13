module ProductsHelper
  def get_star_i key
    Rating.stars[key]
  end
end
