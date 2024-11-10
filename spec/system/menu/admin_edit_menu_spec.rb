require 'rails_helper'

describe 'admin can edit a menu' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'Whopper Duplo', description: 'Pão com gergelim, dois suculentos hambúrgueres de pura carne bovina, duas fatias de cheddar, quatro fatias de picles, alface, tomate, cebola, maionese e ketchup.', calories: 850, restaurant: restaurant)
    Menu.create!(name: 'Lanches', restaurant: restaurant)

    login_as admin, scope: :admin
    visit '/'
    click_on 'Editar Cardápio'
    fill_in 'Nome', with: 'Adicionais'
    check 'Whopper Duplo'
    click_on 'Salvar alterações'

    expect(page).to have_content 'Adicionais'
    expect(page).not_to have_content 'Lanches'
    expect(page).to have_content 'Whopper Duplo'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'Whopper Duplo', description: 'Pão com gergelim, dois suculentos hambúrgueres de pura carne bovina, duas fatias de cheddar, quatro fatias de picles, alface, tomate, cebola, maionese e ketchup.', calories: 850, restaurant: restaurant)
    menu = Menu.create!(name: 'Lanches', restaurant: restaurant)

    login_as admin, scope: :admin
    visit edit_menu_path(menu.id)
    fill_in 'Nome', with: ''
    click_on 'Salvar alterações'

    expect(page).to have_content 'Erro ao tentar atualizar menu'
  end
end