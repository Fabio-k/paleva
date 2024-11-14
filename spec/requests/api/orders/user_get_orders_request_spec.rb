require 'rails_helper'

describe 'user try to get orders' do
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

    get api_orders_path, params: {restaurant_code: 'ABC123'}, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status :ok
    json_response = response.parsed_body
    orders = json_response[:orders][0]
    expect(orders[:code]).to eq 'ABCD1234'
    expect(orders[:status]).to eq 'Aguardando confirmação da cozinha'
    expect(orders[:client][:name]).to eq 'client'
    expect(orders[:client][:phone_number]).to eq '24589332110'
    expect(orders[:items].length).to eq 2
    expect(orders[:items][0][:name]).to eq 'lasanha'
    expect(orders[:items][0][:portion]).to eq 'Lasanha para uma pessoa'
    expect(orders[:items][0][:note]).to eq 'Não adicionar azeitona'
    expect(orders[:items][0][:price]).to eq 3240
    
  end

  it 'search for orders with delivered status' do
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
    other_order = Order.create!(status: :delivered,cpf: CPF.generate, client_name: 'anesia', phone_number: '78245932110', email: 'Anesia@gmail.com', restaurant: restaurant)
    other_order.order_portions.create!(note: 'Colocar em dois pratos', quantity: 1, portion: other_portion)

    get api_orders_path, params: {restaurant_code: 'ABC123', status: 'entregue'}, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status :ok
    json_response = response.parsed_body
    expect(json_response[:orders].length).to eq 1
    expect(json_response[:orders][0][:items][0][:note]).to eq 'Colocar em dois pratos'
    
  end

  it 'search for orders with invalid status' do
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
    other_order = Order.create!(status: :delivered,cpf: CPF.generate, client_name: 'anesia', phone_number: '78245932110', email: 'Anesia@gmail.com', restaurant: restaurant)
    other_order.order_portions.create!(note: 'Colocar em dois pratos', quantity: 1, portion: other_portion)

    get api_orders_path, params: {restaurant_code: 'ABC123', status: 'invalid'}, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status :ok
    json_response = response.parsed_body
    expect(json_response[:orders].length).to eq 2
    
  end

  it 'with fail' do
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa', price: 3240)
    PortionPrice.create!(portion: portion, price: 3240)
    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)

    get api_orders_path, params: {restaurant_code: '123ABC'}, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status :not_found
  end

  it 'And user cant view other restaurant order' do
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

    get api_orders_path, params: {restaurant_code: restaurant.code}, headers: { 'Accept' => 'application/json' }
    json_response = response.parsed_body

    expect(response).to have_http_status :ok
    orders = json_response[:orders]
    expect(orders.length).to eq 1
    expect(orders[0][:code]).to eq order.code
  end
end