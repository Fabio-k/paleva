class MenusController < ApplicationController
  before_action :authenticate_admin!

  def index 
    restaurant = current_admin.restaurant
    @menu = Menu.new
    @menus = restaurant.menus
  end

  def create
    restaurant = current_admin.restaurant
    @menu = Menu.new(menu_params)
    @menu.restaurant = restaurant
    unless @menu.save
      @menus = restaurant.menus
      flash.now[:alert] = "Erro no cadastro do cardápio" 
      return render :index, status: :unprocessable_entity
    end
    redirect_to edit_menu_path(@menu.id)
    
  end

  def edit
    restaurant = current_admin.restaurant
    @items = restaurant.items.where(is_active: true, is_removed: false)
    @menu = restaurant.menus.find(params[:id])
  end

  def update 
    @menu = Menu.find(params[:id])
    restaurant = current_admin.restaurant
    items = restaurant.items
    item_ids = params[:menu][:items].reject!(&:empty?)
    valid_items = items.where(id: item_ids, is_active: true, is_removed: false)
    name = params[:menu][:name]
    if @menu.update(name: name, items: valid_items)
      redirect_to menus_path
    else
      @items = restaurant.items.where(is_active: true, is_removed: false)
      flash.now[:alert] =  'Erro ao tentar atualizar menu'
      render :edit 
    end
  end

  private 

  def menu_params
    params.require(:menu).permit(:name)
  end
end