class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant

  def index 
    @menu = Menu.new
    @menus = @restaurant.menus.valid_menus
    @menus = @restaurant.menus if current_admin
    @order = Order.new
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.restaurant = @restaurant

    unless @menu.save
      @order = Order.new
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
    start_date = params[:menu][:start_date]
    end_date = params[:menu][:end_date]

    unless @menu.update(name: name, items: valid_items, start_date: start_date, end_date: end_date)
      @items = @restaurant.items.valid
      flash.now[:alert] =  'Erro ao tentar atualizar menu'
      return render :edit  
    end

    redirect_to menus_path
  end

  private 

  def set_restaurant

    @restaurant = current_user.restaurant
  end

  def menu_params
    params.require(:menu).permit(:name, :start_date, :end_date)
  end
end