require 'rails_helper'

describe 'admin edit a beverage' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Laranja', description: 'Feito com polpa de laranja na hora', is_alcoholic: false, restaurant: restaurant)

    login_as admin
    visit "/"
    click_on 'Editar'
    within 'div#item_name' do
      fill_in 'Nome', with: 'Suco de maracuja'
    end
    click_on 'Salvar alterações'

    expect(page).to have_content 'Suco de maracuja'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Laranja', description: 'Feito com polpa de laranja na hora', is_alcoholic: false, restaurant: restaurant)

    login_as admin
    visit "/"
    click_on 'Editar'
    within 'div#item_name' do
      fill_in 'Nome', with: ''
    end
    click_on 'Salvar alterações'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_field 'Descrição', with: 'Feito com polpa de laranja na hora'
  end

  it 'but its from another restaurant' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Laranja', description: 'Feito com polpa de laranja na hora', is_alcoholic: false, restaurant: restaurant)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Zelda', last_name: 'Takashi', email: 'zelda@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Mario Restaurant', corporate_name: 'Mario Restaurant LTDA', registration_number: CNPJ.generate, street: 'hokaido street', address_number: '133', city: 'Tokyo', state: 'São Paulo', phone_number: '1197894549', email: 'mario@email.com', admin: other_admin)
    beverage = Beverage.create!(name: 'Mushrom juice', description: 'a very delicious juice', is_alcoholic: true, restaurant: other_restaurant)

    login_as admin
    visit edit_item_path(beverage.id)

    expect(current_path).to eq dashboard_path
    expect(page).not_to have_content 'Mushrom juice'
  end
end