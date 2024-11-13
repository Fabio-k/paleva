class Api::OrdersController < ApiController
  before_action :set_restaurant
  def index

    @orders = @restaurant.orders

    status = params[:status]
    translated_status = translate_status(status)
    @orders = @restaurant.orders.where(status: translated_status) if translated_status.present?
    
  end

  def show
      @order = @restaurant.orders.find_by(code: params[:order_code])
      return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(code: params[:restaurant_code])

    return render json: {error: 'Restaurante não encontrado'}, status: :not_found if @restaurant.nil?
  end

  def translate_status(status)
    Order.statuses.each do |key, _|
      return key if Order.human_attribute_name("status.#{key}") == status
    end

    nil
  end
end