class CaracteristicsController < ApplicationController
  def create
    caracteristic = Caracteristic.new(caracteristic_params)
    if caracteristic.save
      redirect_to new_item_path
    end
  end

  private

  def caracteristic_params
    params.require(:caracteristic).permit(:name)
  end
end