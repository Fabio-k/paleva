require 'rails_helper'

describe 'admin view beverage details' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Laranja', description: 'Feito com polpa de laranja na hora', is_alcoholic: false, restaurant: restaurant)

    login_as admin
    visit "/"
    click_on 'Suco de Laranja'

    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content 'Feito com polpa de laranja na hora'
    expect(page).to have_content 'Bebida não alcólica'
  end

  it 'but its from other restaurant' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Beverage.create!(name: 'Suco de laranja', description: 'da polpa da laranja', is_alcoholic: false, restaurant: restaurant)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Ronaldo', last_name: 'Ferreira', email: 'ronaldo@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Sr. Marmita', corporate_name: 'Sr. Marmita LTDA', registration_number: CNPJ.generate, street: 'Avenida das bandeiras', address_number: '334', city: 'Poa', state: 'São Paulo', phone_number: '1177897548', email: 'srmarmita@email.com', admin: other_admin)
    beverage = Beverage.create!(name: 'Suco de melancia', description: 'feito na hora', is_alcoholic: false, restaurant: other_restaurant)

    login_as admin
    visit beverage_path(beverage.id)

    expect(page).to have_content 'Bebida não encontrada'
    expect(page).not_to have_content 'Suco de melancia'
  end
end