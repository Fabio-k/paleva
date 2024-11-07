require 'rails_helper'

describe 'admin edit a dish' do
  it 'and should be authenticated' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    visit edit_item_path(dish.id)
    expect(current_path).to eq new_admin_session_path
  end

  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    login_as admin
    visit "/"
    within 'nav' do
      click_on 'itens'
    end
    click_on 'lasanha'
    click_on 'Editar'
    within 'div#item_name' do
       fill_in 'Nome', with: 'Lasanha de abóbora'
    end
    click_on 'Salvar alterações'

    expect(page).to have_content 'Lasanha de abóbora'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    login_as admin
    visit edit_item_path(item.id)
    within 'div#item_name' do
       fill_in 'Nome', with: ''
    end
    click_on 'Salvar alterações'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end