class CaracteristicsController < ApplicationController
  before_action :authenticate_admin!
  def create
    caracteristic = Caracteristic.new(caracteristic_params)
    caracteristic.restaurant = current_admin.restaurant
    if caracteristic.save
      redirect_to new_item_path
    end
  end

  private

  def caracteristic_params
    params.require(:caracteristic).permit(:name)
  end
end