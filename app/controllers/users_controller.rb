class UsersController < ApplicationController
  before_action :check_logged_in, only: :new
  before_action :load_user, :correct_user, only: [:show, :change_password]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "users.register_success"
      redirect_to root_url
    else
      flash.now[:danger] = t "users.register_fail"
      render :new
    end
  end

  def change_password; end

  def update_change_password; end

  private

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def user_params
    sex_to_i unless params[:user][:sex].blank?
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :sex, :birthday, :phone, :address, :picture
  end

  def sex_to_i
    params[:user][:sex] = params[:user][:sex].to_i
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users.user_not_found"
    redirect_to root_path
  end
end
