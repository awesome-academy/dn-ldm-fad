class Admin::CategoriesController < Admin::AdminsController
  before_action :load_categories, only: [:index, :create]
  before_action :load_category, only: [:edit, :update, :destroy]

  def index
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "admin.categories.add_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "admin.categories.add_fail"
      render :index
    end
  end

  def edit; end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "admin.categories.update_success"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t "admin.categories.update_fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.categories.destroy_success"
    else
      flash[:danger] = t "admin.categories.destroy_fail"
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit :name, :description
  end

  def load_categories
    @categories = Category.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.user.paginate
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = "categories.not_found"
    redirect_to admin_categories_path
  end
end
