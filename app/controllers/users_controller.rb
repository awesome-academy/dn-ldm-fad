class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, :correct_user

  def show; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "users.update_success"
    else
      flash[:danger] = t "users.update_fail"
    end
    redirect_to @user
  end

  def change_password; end

  def update_change_password
    if params[:old_password].blank?
      @user.errors.add(:password, t("users.not_empty"))
      render :change_password
    elsif check_old_password
      flash.now[:danger] = t "users.old_password_wrong"
      render :change_password
    elsif @user.update_attributes(user_params)
      flash[:success] = t "users.change_password_success"
      bypass_sign_in @user
      redirect_to @user
    else
      render :change_password
    end
  end

  private

  def check_old_password
    !@user.valid_password? params[:old_password]
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :sex, :birthday, :phone, :address, :picture
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users.user_not_found"
    redirect_to root_path
  end
end
