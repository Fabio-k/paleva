class ItensController < ApplicationController
  before_action :set_dish
  
  def change_status
    @item.is_active = !@item.is_active
    if @item.save
      redirect_to dish_path(@item.id) if @item.type == 'Dish'
      redirect_to beverage_path(@item.id) if @item.type == 'Beverage'
    else
      redirect_to dashboard_path, alert: 'Erro ao atualizar o status do item'
    end

  end

  private

  def set_dish
    @item = Item.find(params[:id])
    redirect_to dashboard_path, notice: 'Prato não foi encontrado' unless admin_owns_item?
  end

  def admin_owns_item?
    @item.restaurant.admin == current_admin
  end
end