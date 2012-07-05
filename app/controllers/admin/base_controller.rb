class Admin::BaseController < ApplicationController
  #layout 'admin'
  #before_filter :require_admin_user
  def sub_layout
   "admin"
  end
end
