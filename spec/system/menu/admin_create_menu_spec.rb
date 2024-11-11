require 'rails_helper'

describe 'admin create a menu' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'Whopper Duplo', description: 'Pão com gergelim, dois suculentos hambúrgueres de pura carne bovina, duas fatias de cheddar, quatro fatias de picles, alface, tomate, cebola, maionese e ketchup.', calories: 850, restaurant: restaurant)
    Dish.create!(name: 'Whopper Barbecue Bacon', description: 'Adicionamos no nosso WHOPPER® um delicioso molho barbecue e fatias super crocantes de bacon. Resultado: Perfeição!', calories: 440, restaurant: restaurant)

    login_as admin, scope: :admin
    visit '/'
    fill_in 'menu_name_field', with: 'Sanduíches Especiais'
    click_on '+'
    check 'Whopper Duplo'
    click_on 'Salvar alterações'

    expect(page).to have_content 'Sanduíches Especiais'
    expect(page).to have_content 'Whopper Duplo'
    expect(page).not_to have_content 'Whopper Barbecue Bacon'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'Whopper Duplo', description: 'Pão com gergelim, dois suculentos hambúrgueres de pura carne bovina, duas fatias de cheddar, quatro fatias de picles, alface, tomate, cebola, maionese e ketchup.', calories: 850, restaurant: restaurant)
    
    login_as admin, scope: :admin
    visit menus_path
    fill_in 'menu_name_field', with: ''
    click_on '+'

    expect(page).to have_content 'Erro no cadastro do cardápio'
  end

  it 'and cant see other restaurant\'s menu' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Menu.create!(name: 'Lanches', restaurant: restaurant)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Luke', last_name: 'Skywalker', email: 'luke@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Death star stop', corporate_name: 'Star Wars LTDA', registration_number: CNPJ.generate, street: 'sectio 42Bf', address_number: 'fd3', city: 'Death star', state: 'Death star', phone_number: '6574837394', email: 'burgerking@email.com', admin: other_admin)
    Menu.create!(name: 'Bebidas', restaurant: other_restaurant)
    
    login_as admin, scope: :admin
    visit '/'

    expect(page).to have_content 'Lanches'
    expect(page).not_to have_content 'Bebidas'
  end
end