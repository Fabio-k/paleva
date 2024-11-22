require 'rails_helper'

describe 'user try to filter by caracteristic', js: true do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    Beverage.create!(name: 'Suco de laranja', description: 'da polpa da laranja', is_alcoholic: false, restaurant: restaurant)
    caracteristic = Caracteristic.create!(name: 'Picante', restaurant: restaurant)
    ItemCaracteristic.create!(item: item, caracteristic: caracteristic)

    login_as admin, scope: :admin
    visit '/'
    click_on 'Itens'
    find('#Picantelabel').click

    expect(page).to have_content 'lasanha'
    expect(page).not_to have_content 'Suco de laranja'
  end

  it 'And cant see others restaurant caracteristic' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    Beverage.create!(name: 'Suco de laranja', description: 'da polpa da laranja', is_alcoholic: false, restaurant: restaurant)
    caracteristic = Caracteristic.create!(name: 'Picante', restaurant: restaurant)
    ItemCaracteristic.create!(item: item, caracteristic: caracteristic)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Link', last_name: 'Hyrule', email: 'link@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Hyrulian Cafe', corporate_name: 'Hyrulian LTDA', registration_number: CNPJ.generate, street: 'Avenida korok street', address_number: '222', city: 'Hyrule', state: 'Hyrule', phone_number: '1111122200', email: 'hyrulecafe@email.com', admin: other_admin)
    Caracteristic.create!(name: '4 hearts', restaurant: other_restaurant)

    login_as admin, scope: :admin
    visit items_path

    expect(page).to have_content 'lasanha'
    expect(page).not_to have_content '4 hearts'
  end
end