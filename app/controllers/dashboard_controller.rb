class DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @restaurant = current_admin.restaurant
  end
end