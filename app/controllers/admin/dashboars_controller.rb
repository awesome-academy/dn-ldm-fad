class Admin::DashboarsController < Admin::AdminsController
  def index
    @count_product = Product.count
    @count_category = Category.count
    @count_user = User.count
    @count_order = Order.count
  end
end
