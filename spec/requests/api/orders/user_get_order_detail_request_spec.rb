require 'rails_helper'

describe 'user try to get order detail' do
  it 'with success' do
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_call_original

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

    get api_order_path, params: {restaurant_code: 'ABC123', order_code: order.code}, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status :ok
    json_response = response.parsed_body
    expect(json_response[:client_name]).to eq 'client'
    expect(json_response[:entry_data]).to eq order.created_at.as_json
    expect(json_response[:status]).to eq 'Aguardando confirmação da cozinha'
    item1 = json_response[:items].find {|item| item[:portion] == 'Lasanha para uma pessoa'}
    expect(item1.present?).to eq true
    expect(item1[:name]).to eq 'lasanha'
    expect(item1[:note]).to eq 'Não adicionar azeitona'
    
  end

  it 'with fail' do
    allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_call_original

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

    get api_order_path, params: {restaurant_code: 'ABC123', order_code: 'SBFF1234'}, headers: { 'Accept' => 'application/json' }

    json_response = response.parsed_body
    expect(response).to have_http_status :not_found
    expect(json_response[:error]).to eq 'Pedido não encontrado'
  end
end