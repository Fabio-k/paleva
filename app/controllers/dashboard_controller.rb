class DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @restaurant = current_admin.restaurant
    @dishes = @restaurant.dishes
    @beverages = @restaurant.beverages
  end
end