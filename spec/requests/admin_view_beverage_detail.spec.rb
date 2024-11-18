require 'rails_helper'

describe 'user see beverage details' do
  it 'but its other restaurant\'s beverage' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Beverage.create!(name: 'Suco de laranja', description: 'da polpa da laranja', is_alcoholic: false, restaurant: restaurant)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Ronaldo', last_name: 'Ferreira', email: 'ronaldo@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Sr. Marmita', corporate_name: 'Sr. Marmita LTDA', registration_number: CNPJ.generate, street: 'Avenida das bandeiras', address_number: '334', city: 'Poa', state: 'São Paulo', phone_number: '1177897548', email: 'srmarmita@email.com', admin: other_admin)
    beverage = Beverage.create!(name: 'Suco de melancia', description: 'feito na hora', is_alcoholic: false, restaurant: other_restaurant)

    login_as admin, scope: :admin
    get item_path(beverage.id)
    expect(response).to redirect_to items_path
    follow_redirect!
    expect(response.body).to include('Bebida não encontrada')
  end
end