class BeveragesController < ApplicationController

  before_action :set_beverage_and_valid_owner, only: [:show, :edit, :update, :destroy, :change_status]
  def new
    @beverage = Beverage.new
  end
  
  def create
    @beverage = Beverage.new(beverage_params)
    @beverage.restaurant = current_admin.restaurant
    if @beverage.save
      redirect_to @beverage
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    
  end

  def edit
  end

  def update
    if @beverage.update(beverage_params)
      redirect_to @beverage
    else
      render 'edit', status: :unprocessable_entity
    end

  end

  def destroy
    flash[:alert] = 'Bebida não encontrada' unless @beverage.delete
    redirect_to dashboard_path
  end

  def change_status
    @beverage.is_active = !@beverage.is_active
    if @beverage.save
      redirect_to @beverage
    else
      flash[:notice] = 'Erro ao tentar mudar status'
      render 'show'
    end
  end


  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :is_alcoholic, :photo, :calories)
  end

  def set_beverage_and_valid_owner
    @beverage = Beverage.find(params[:id])
    
    redirect_to dashboard_path, alert: 'Bebida não encontrada'  unless user_own_beverage?
  end

  def user_own_beverage?
    current_admin.restaurant.beverages.include?(@beverage)
  end

end