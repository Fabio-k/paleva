require 'rails_helper'

describe 'admin sees details of a dish' do
  it 'and can turn off a beverage' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    login_as admin
    visit '/'
    click_on 'lasanha'
    click_on 'Desativar'

    expect(page).to have_content 'lasanha'
    expect(page).to have_content 'Desativado'
  end
end