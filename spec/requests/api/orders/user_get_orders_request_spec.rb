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

    get api_orders_path, params: {code: 'ABC123'}, headers: { 'Accept' => 'application/json' }

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

    get api_orders_path, params: {code: 'ABC123', status: 'entregue'}, headers: { 'Accept' => 'application/json' }

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

    get api_orders_path, params: {code: 'ABC123', status: 'invalid'}, headers: { 'Accept' => 'application/json' }

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

    get api_orders_path, params: {code: '123ABC'}, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status :not_found
  end
end