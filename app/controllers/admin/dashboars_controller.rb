class Admin::DashboarsController < ApplicationController
  layout "admin", only: :index
  before_action :check_admin?, only: :index

  def index
    @count_product = Product.count
    @count_category = Category.count
    @count_user = User.count
    @count_order = Order.count
  end
end
