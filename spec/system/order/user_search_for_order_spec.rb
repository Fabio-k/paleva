require 'rails_helper'

describe 'user try to seach for an order' do
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
    order.order_statuses.create!

    visit '/'
    click_on 'Consultar status do pedido'
    fill_in 'code', with: 'ABCD1234'
    find("#search_item").click


    expect(page).to have_content 'Burger King'
    expect(page).to have_content 'Avenida cívica, 103, Mogi das Cruzes, São Paulo'
    expect(page).to have_content 'Data de criação'
    expect(page).to have_content "#{order.created_at.strftime('%H:%M')} #{I18n.localize(order.created_at.to_date)}"

  end
end