class Admin::AdminsController < ApplicationController
  layout "admin"
  before_action :is_admin?

  private

  def is_admin?
    return if current_user.try :admin?
    flash[:danger] = t "users.not_admin"
    redirect_to root_url
  end
end
