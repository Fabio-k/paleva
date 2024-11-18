require 'rails_helper'

describe 'user try to update order status to canceled' do
  it 'with success' do
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa')
    other_portion = Portion.create!(item: item, description: 'Lasanha para duas pessoa')
    PortionPrice.create!(portion: portion, price: 3240)
    PortionPrice.create!(portion: other_portion, price: 5380)
    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)
    order.order_portions.create!(note: 'Colocar em três pratos', quantity: 1, portion: other_portion)

    patch api_order_cancel_path, params: {restaurant_code: 'ABC123', order_code: order.code, reason_message: 'Impossível fazer sem azeitona'}, headers: { 'Accept' => 'application/json' }
    expect(response).to have_http_status :ok
  end

  it 'with success' do
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa')
    other_portion = Portion.create!(item: item, description: 'Lasanha para duas pessoa')
    PortionPrice.create!(portion: portion, price: 3240)
    PortionPrice.create!(portion: other_portion, price: 5380)
    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)
    order.order_portions.create!(note: 'Colocar em três pratos', quantity: 1, portion: other_portion)

    patch api_order_cancel_path, params: {restaurant_code: 'ABC123', order_code: order.code}, headers: { 'Accept' => 'application/json' }
    expect(response).to have_http_status :unprocessable_entity
  end

  it 'And fail because he cant cancel a order that is already ready' do
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa')
    other_portion = Portion.create!(item: item, description: 'Lasanha para duas pessoa')
    PortionPrice.create!(portion: portion, price: 3240)
    PortionPrice.create!(portion: other_portion, price: 5380)
    order = Order.create!(status: :ready, cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)
    order.order_portions.create!(note: 'Colocar em três pratos', quantity: 1, portion: other_portion)

    patch api_order_cancel_path, params: {restaurant_code: 'ABC123', order_code: order.code, reason_message: 'Impossível fazer sem azeitona'}, headers: { 'Accept' => 'application/json' }
    expect(response).to have_http_status :unprocessable_entity
  end

  it 'And fail because he cant update other restaurant order' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa')
    PortionPrice.create!(portion: portion, price: 3240)
    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Sakura', last_name: 'Haruno', email: 'sakura@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Seven Eleven', corporate_name: 'Seven Eleven LTDA', registration_number: CNPJ.generate, street: 'Tobirama street', address_number: '3', city: 'Konoha', state: 'País do Fogo', phone_number: '1160894339', email: 'elevenseven@email.com', admin: other_admin)
    item = Dish.create!(name: 'Lamen', description: 'O segundo melhor da vila', restaurant: other_restaurant)
    portion = Portion.create!(item: item, description: 'Para uma pessoa')
    PortionPrice.create!(portion: portion, price: 3240)
    other_order = Order.create!(cpf: CPF.generate, client_name: 'Naruto', phone_number: '24589332110', email: 'naruto@gmail.com', restaurant: other_restaurant)
    other_order.order_portions.create!(note: 'deixar bem quente', quantity: 1, portion: portion)


    patch api_order_accept_path, params: {restaurant_code: restaurant.code, order_code: other_order.code, reason_message: "teste"}, headers: { 'Accept' => 'application/json' }
    json_response = response.parsed_body

    expect(response).to have_http_status :not_found
    expect(json_response[:error]).to eq 'Pedido não encontrado'
  end
end