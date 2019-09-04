module ProductsHelper
  def get_star_i key
    Rating.stars[key]
  end

  def load_select_price
    prices = Hash.new
    prices[t "search.price.one"] = Settings.price.one
    prices[t "search.price.two"] = Settings.price.two
    prices[t "search.price.three"] = Settings.price.three
    prices[t "search.price.four"] = Settings.price.four
    prices.map{|k, v| [k, v]}
  end
end
