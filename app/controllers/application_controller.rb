class ApplicationController < ActionController::Base
  include SessionsHelper
  include CartsHelper
  protect_from_forgery with: :exception
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def check_logged_in
    redirect_to root_path if logged_in?
  end

  def check_logged_out
    return if logged_in?
    store_location
    flash[:warning] = t "users.logged_out_user"
    redirect_to login_url
  end

  def load_cart_session
    session[:carts] ||= {}
    @carts = session[:carts]
  end

  def check_admin?
    return if logged_in? && current_user.admin?
    flash[:danger] = t "users.not_admin"
    redirect_to root_url
  end
end
