class DishesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_dish, only: [:show, :edit, :update, :destroy, :change_status]
  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.restaurant = current_admin.restaurant
    if @dish.save
      redirect_to @dish
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @dish.update(dish_params)
      redirect_to @dish, notice: 'Prato alterado com sucesso'
    else
      render 'new'
    end
  end

  def show
    
  end

  def destroy
    if @dish.delete
      redirect_to dashboard_path
    else
      render 'show'
    end
  end

  def change_status
    @dish.is_active = !@dish.is_active
    if @dish.save
      redirect_to @dish
    end

  end

  private 

  def set_dish
    @dish = Dish.find(params[:id])
    redirect_to dashboard_path, notice: 'Prato não foi encontrado' unless admin_owns_dish?
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :photo)
  end

  def admin_owns_dish?
    current_admin.restaurant.dishes.include?(@dish)
  end
end