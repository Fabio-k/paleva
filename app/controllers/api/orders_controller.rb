class Api::OrdersController < ApiController
  before_action :set_restaurant
  def index

    @orders = @restaurant.orders.visible_status_to_client

    status = params[:status]
    translated_status = translate_status(status)
    @orders = @restaurant.orders.where(status: translated_status) if translated_status.present?
    
  end

  def show
      @order = @restaurant.orders.find_by(code: params[:order_code])
      return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?
  end

  def accept 
    @order = @restaurant.orders.visible_status_to_client.find_by(code: params[:order_code])
    return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?

    return render json: {message: 'Erro ao tentar atualizar pedido'}, status: :unprocessable_entity unless @order.update(status: :in_progress)

    render json: {message: 'Pedido criado com sucesso'}, statis: :ok 
  end

  def ready
    @order = @restaurant.orders.find_by(code: params[:order_code])
    return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?

    return render json: {message: 'Erro ao tentar atualizar pedido'}, status: :unprocessable_entity unless @order.update(status: :ready)

    render json: {message: 'Pedido criado com sucesso'}, statis: :ok 
  end

  def cancel
    @order = @restaurant.orders.visible_status_to_client.find_by(code: params[:order_code])
    return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?

    return render json: {message: 'Erro ao tentar atualizar pedido'}, status: :unprocessable_entity unless @order.update(status: :canceled, reason_message: params[:reason_message])

    render json: {message: 'Pedido criado com sucesso'}, statis: :ok 
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