require 'rails_helper'

describe 'user try to acess new portion page' do
  it 'As an admin and succed' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
      
    login_as admin, scope: :admin
    get new_item_portion_path(dish.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Criar Porção'
  end

  it 'As an admin and fail because he dont own item' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
      
    other_admin = Admin.create!(cpf: CPF.generate, name: 'Ronaldo', last_name: 'Ferreira', email: 'ronaldo@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Sr. Marmita', corporate_name: 'Sr. Marmita LTDA', registration_number: CNPJ.generate, street: 'Avenida das bandeiras', address_number: '334', city: 'Poa', state: 'São Paulo', phone_number: '1177897548', email: 'srmarmita@email.com', admin: other_admin)
    beverage = Beverage.create!(name: 'Suco de melancia', description: 'feito na hora', is_alcoholic: false, restaurant: other_restaurant)

    login_as admin, scope: :admin
    get new_item_portion_path(beverage.id)
    follow_redirect!
    expect(response.body).not_to include 'Criar Porção'
  end
end