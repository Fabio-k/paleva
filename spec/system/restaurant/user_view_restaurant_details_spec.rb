require 'rails_helper'

describe 'user view restaurant details' do
  it 'with success' do
    cnpj = CNPJ.generate
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: cnpj, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    
    login_as admin, scope: :admin
    visit '/'
    click_on 'Burger King'
    
    expect(page).to have_content 'Burger King'
    expect(page).to have_content 'Burger King LTDA'
    expect(page).to have_content cnpj
  end

  it 'and cant see other person\'s restaurant' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    
    other_admin = Admin.create!(cpf: CPF.generate, name: 'Luke', last_name: 'Skywalker', email: 'luke@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Death star stop', corporate_name: 'Star Wars LTDA', registration_number: CNPJ.generate, street: 'sectio 42Bf', address_number: 'fd3', city: 'Death star', state: 'Death star', phone_number: '6574837394', email: 'burgerking@email.com', admin: other_admin)
    
    login_as admin, scope: :admin

    visit restaurant_path(other_restaurant.id)

    expect(page).to have_content 'Burger King'
    expect(page).not_to have_content 'Death star stop'
  end
end