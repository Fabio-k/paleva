require 'rails_helper'

describe 'user delete beverage' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Feito com polpa de laranja na hora', is_alcoholic: false, restaurant: restaurant)

    login_as admin
    visit "/"
    within 'nav' do
      click_on 'itens'
    end
    click_on 'Remover'

    expect(page).not_to have_content 'Suco de Laranja'
    expect(Beverage.exists?(beverage.id)).to eq true
  end
end