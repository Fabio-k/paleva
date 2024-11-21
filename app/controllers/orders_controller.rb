class OrdersController < ApplicationController
  before_action :authenticate_user!
  def create
    order_params = params.require(:order).permit(:cpf, :client_name, :email, :phone_number)
    order_portions_params = params[:order][:order_portions] 

    @order = Order.new(order_params)
    restaurant = current_user.restaurant
    @order.restaurant = restaurant

    unless order_portions_params
      @menu = Menu.new
      @menus = restaurant.menus
      flash.now[:alert] = 'Pedido deve ter ao menos uma porção vinculada ao pedido'
      return render 'menus/index', status: :unprocessable_entity
    end

    begin
      ActiveRecord::Base.transaction do
        if @order.save
          create_order_portions(order_portions_params)
          @order.calculate_total
          @order.save
          redirect_to menus_path, notice: 'Pedido criado com sucesso'
        else
          flash.now[:alert] = "Erro ao tentar salvar pedido"
          render 'menus/index', status: :unprocessable_entity
        end
      end

    rescue => e
      @menu = Menu.new
      @menus = restaurant.menus
      flash.now[:alert] = "Erro ao tentar salvar pedido"
      return render 'menus/index', status: :unprocessable_entity
    end
    
   
  end

  private

  def create_order_portions(order_portions_params)
    restaurant = current_user.restaurant
    order_portions_params.each do |item|
      menu_id = item[:menu_id]
      portion_id = item[:portion_id]
      quantity = item[:quantity]
      note = item[:note]

      menu = restaurant.menus.find_by(id: menu_id)
      if !menu || menu.unavailable?
        raise 'Menu indisponível'
      end
      
      portion = Portion.find(portion_id)
      if restaurant.items.include?(portion.item)
        @order.order_portions.create(portion: portion, quantity: quantity, note: note)
      end 
    end
  end

end