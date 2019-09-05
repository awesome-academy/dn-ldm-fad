class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :check_logged_in, only: :new

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_back_or root_url
    else
      flash.now[:danger] = t "users.login_fail"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:warning] = t "users.user_not_found"
    redirect_to login_path
  end
end
