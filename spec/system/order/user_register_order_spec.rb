require 'rails_helper'

describe 'user register a new order', js: true do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Garfield Restaurant', corporate_name: 'Garfield LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'Lasanha', description: 'dupla camada de queijo', calories: 850, restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa', price: 3240)
    PortionPrice.create!(portion: portion, price: 3240)
    Menu.create!(name: 'Lanches', restaurant: restaurant, items: [item])

    login_as admin
    visit '/'
    find(".menu_dropdown").click
    click_on 'Adicionar Porção'
    fill_in 'order[client_name]', with: 'Garfield'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'garfield@email.com'
    fill_in 'Numero de telefone', with: '2248934920'
    click_on 'Salvar'

    expect(page).to have_content 'Pedido criado com sucesso'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Garfield Restaurant', corporate_name: 'Garfield LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'Lasanha', description: 'dupla camada de queijo', calories: 850, restaurant: restaurant)
    Menu.create!(name: 'Lanches', restaurant: restaurant, items: [item])

    login_as admin
    visit '/'
    fill_in 'order[client_name]', with: 'Garfield'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'garfield@email.com'
    fill_in 'Numero de telefone', with: '2248934920'
    click_on 'Salvar'

    expect(page).to have_content 'Pedido deve ter ao menos uma porção vinculada ao pedido'
  end
end