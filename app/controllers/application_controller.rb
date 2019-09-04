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
end
