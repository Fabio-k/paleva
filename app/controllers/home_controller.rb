class HomeController < ApplicationController
  def index
    if admin_signed_in?
      redirect_to dashboard_path
    end
  end
end