class DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @restaurant = current_admin.restaurant
    @dishes = @restaurant.dishes
    @beverages = @restaurant.beverages
  end

  def search
    restaurant = current_admin.restaurant
    @query = params[:query]
    @beverages = restaurant.beverages.where 'name LIKE ? OR description LIKE ?', "%#{params[:query]}%", "%#{@query}%"
    @dishes = restaurant.dishes.where 'name LIKE ? OR description LIKE ?', "%#{params[:query]}%", "%#{@query}%"
  end
end