class HomeController < ApplicationController
  layout 'devise'
  def index
    if admin_signed_in?
      redirect_to dashboard_path
    end
  end
end