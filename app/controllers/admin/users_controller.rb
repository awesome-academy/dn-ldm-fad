class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :check_admin?
  before_action :load_user, only: [:edit, :update, :destroy]

  def index
    @users = User.sort_desc.paginate page: params[:page],
      per_page: Settings.user.paginate
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.update_success"
      redirect_to admin_users_path
    else
      flash[:danger] = t "users.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy_success"
    else
      flash[:danger] = t "users.destroy_fail"
    end
    redirect_to admin_users_path
  end

  def search
    tr = params[:search].tr " ", "%"
    users = User.by_name_email_phone(tr).sort_desc.paginate page: params[:page],
      per_page: Settings.user.paginate
    respond_to do |format|
      format.json{render json: {users: users}}
    end
  end

  private

  def user_params
    sex_to_i unless params[:user][:sex].blank?
    params.require(:user).permit :name, :sex, :birthday, :phone, :address
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = "users.not_found"
    redirect_to admin_path
  end

  def sex_to_i
    params[:user][:sex] = params[:user][:sex].to_i
  end
end
