class UsersController < ApplicationController
  before_action :check_logged_in, only: :new

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

  private

  def user_params
    sex_to_i unless params[:user][:sex].blank?
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :sex, :birthday, :phone, :address
  end

  def sex_to_i
    params[:user][:sex] = params[:user][:sex].to_i
  end
end
