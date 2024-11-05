class DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @restaurant = current_admin.restaurant
    @items = @restaurant.items.where(is_removed: false)
  end

  def search
    restaurant = current_admin.restaurant
    @query = params[:query]
    @items = restaurant.items.where 'name LIKE ? OR description LIKE ?', "%#{params[:query]}%", "%#{@query}%"
  end
end