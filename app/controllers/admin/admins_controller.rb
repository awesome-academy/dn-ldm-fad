class Admin::AdminsController < ApplicationController
  layout "admin"
  before_action :check_admin?
end
