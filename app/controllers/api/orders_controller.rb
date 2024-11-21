class Api::OrdersController < ApiController
  before_action :set_restaurant
  def index

    @orders = @restaurant.orders.select {|order| order.current_status != 'canceled'}

    status = params[:status]
    translated_status = translate_status(status)

    if translated_status.present?
      @orders = @restaurant.orders.select {|order| order.current_status == translated_status} if translated_status.present?
    end
    
  end

  def show
      @order = get_order
      return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?
  end

  def accept 
    @order = get_order
    return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?
    result = @order.order_statuses.create(status: :in_progress)
    return render json: {message: 'Erro ao tentar atualizar pedido'}, status: :unprocessable_entity unless result.persisted?

    render json: {message: 'Pedido criado com sucesso'}, statis: :ok 
  end

  def ready
    @order = get_order
    return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?

    return render json: {message: 'Erro ao tentar atualizar pedido'}, status: :unprocessable_entity unless @order.order_statuses.create(status: :ready).persisted?

    render json: {message: 'Pedido criado com sucesso'}, statis: :ok 
  end

  def cancel
    @order = get_order
    return render json: {error: 'Pedido não encontrado'}, status: :not_found if @order.nil?

    @order.reason_message = params[:reason_message]
    @order.save!
    return render json: {message: 'Erro ao tentar atualizar pedido'}, status: :unprocessable_entity unless @order.order_statuses.create(status: :canceled).persisted?

    render json: {message: 'Pedido criado com sucesso'}, statis: :ok 
  end

  private

  def valid_orders 
    @restaurant.orders.select {|order| order.current_status != 'canceled'}
  end

  def get_order
    valid_orders.select {|order| order.code ==  params[:order_code]}.first
  end

  def set_restaurant
    @restaurant = Restaurant.find_by(code: params[:restaurant_code])

    return render json: {error: 'Restaurante não encontrado'}, status: :not_found if @restaurant.nil?
  end

  def translate_status(status)
    OrderStatus.statuses.each do |key, _|
      return key if OrderStatus.human_attribute_name("status.#{key}") == status
    end

    nil
  end
end