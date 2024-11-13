class Api::OrdersController < ApiController
  def index
    restaurant = Restaurant.find_by(code: params[:code])
   
    unless restaurant
      return render json: {error: 'Restaurante não encontrado'}, status: :not_found
    end

    @orders = restaurant.orders

    status = params[:status]
    translated_status = translate_status(status)
    @orders = restaurant.orders.where(status: translated_status) if translated_status.present?
    
  end

  private

  def translate_status(status)
    Order.statuses.each do |key, _|
      return key if Order.human_attribute_name("status.#{key}") == status
    end

    nil
  end
end