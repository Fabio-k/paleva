require 'rails_helper'

describe 'admin visit dashboard' do
  it 'and should be authenticated' do
    visit dashboard_path
    expect(current_path).to eq new_admin_session_path
  end

  it 'and should have a restaurant' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')

    login_as admin
    visit dashboard_path
    expect(current_path).to eq new_restaurant_path
  end

  it 'and see restaurants details' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin
    visit dashboard_path

    expect(page).to have_content 'Burger King'

  end

  it 'and see its own dishes' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Ronaldo', last_name: 'Ferreira', email: 'ronaldo@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Sr. Marmita', corporate_name: 'Sr. Marmita LTDA', registration_number: CNPJ.generate, street: 'Avenida das bandeiras', address_number: '334', city: 'Poa', state: 'São Paulo', phone_number: '1177897548', email: 'srmarmita@email.com', admin: other_admin)
    Dish.create!(name: 'feijoada', description: 'feijoada feita no forno à lenha', restaurant: other_restaurant)

    login_as admin
    visit "/"
    expect(page).to have_content 'lasanha'
    expect(page).not_to have_content 'feijoada'
  end
end