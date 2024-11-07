class MenusController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_restaurant

  def index 
    @menu = Menu.new
    @menus = @restaurant.menus
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.restaurant = @restaurant

    unless @menu.save
      @menus = @restaurant.menus
      flash.now[:alert] = "Erro no cadastro do cardápio" 

      return render :index, status: :unprocessable_entity
    end
    redirect_to edit_menu_path(@menu.id)
    
  end

  def edit
    @items = @restaurant.items.valid
    @menu = @restaurant.menus.find(params[:id])
  end

  def update 
    @menu = Menu.find(params[:id])
    item_ids = params[:menu][:items].reject!(&:empty?)
    valid_items = @restaurant.items.valid.where(id: item_ids)
    name = params[:menu][:name]

    unless @menu.update(name: name, items: valid_items)
      @items = @restaurant.items.valid
      flash.now[:alert] =  'Erro ao tentar atualizar menu'
      return render :edit  
    end

    redirect_to menus_path
  end

  private 

  def set_restaurant
    @restaurant = current_admin.restaurant
  end

  def menu_params
    params.require(:menu).permit(:name)
  end
end