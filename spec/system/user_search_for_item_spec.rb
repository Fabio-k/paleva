require 'rails_helper'

describe 'user search for dish or beverage' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Limão', description: 'Feito com polpa de limão na hora', is_alcoholic: false, photo: Rails.root.join('spec', 'support', 'sucodelimao.jpeg') ,restaurant: restaurant)
    Beverage.create!(name: 'Suco de Laranja', description: 'Feito na hora', is_alcoholic: false, restaurant: restaurant)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', photo: Rails.root.join('spec', 'support', 'lasanhadequeijo.jpeg'), restaurant: restaurant)
    Dish.create!(name: 'hamburger', description: 'vegetariano', restaurant: restaurant)

    login_as admin, scope: :admin
    visit "/"
    fill_in 'Pesquisar por item', with: 'com'
    click_on 'Pesquisar'

    expect(page).to have_content 'Resultados da pesquisa'
    expect(page).to have_css 'img[src*="lasanhadequeijo.jpeg"]'
    expect(page).to have_css 'img[src*="sucodelimao.jpeg"]'
    expect(page).to have_link 'lasanha'
    expect(page).to have_link 'Lasanha de queijo com abóbora'
    expect(page).to have_link 'Suco de Limão'
    expect(page).to have_link 'Feito com polpa de limão na hora'
    expect(page).not_to have_link 'hamburger'
    expect(page).not_to have_link 'Suco de Laranja'
  end

  it 'with no result' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Limão', description: 'Feito com polpa de limão na hora', is_alcoholic: false, photo: Rails.root.join('spec', 'support', 'sucodelimao.jpeg') ,restaurant: restaurant)
    Dish.create!(name: 'hamburger', description: 'vegetariano', restaurant: restaurant)

    login_as admin, scope: :admin
    visit "/"
    fill_in 'Pesquisar por item', with: 'zark'
    click_on 'Pesquisar'

    expect(page).to have_content 'Resultados da pesquisa'
    expect(page).to have_content "Nenhum item com nome ou descrição com 'zark' encontrado"
  end

  it 'match by name' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Limão', description: 'Feito com polpa de limão na hora', is_alcoholic: false, photo: Rails.root.join('spec', 'support', 'sucodelimao.jpeg') ,restaurant: restaurant)
    Beverage.create!(name: 'Suco de Laranja', description: 'Feito na hora', is_alcoholic: false, restaurant: restaurant)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', photo: Rails.root.join('spec', 'support', 'lasanhadequeijo.jpeg'), restaurant: restaurant)
    Dish.create!(name: 'hamburger', description: 'vegetariano', restaurant: restaurant)

    login_as admin, scope: :admin
    visit "/"
    fill_in 'Pesquisar por item', with: 'Suco'
    click_on 'Pesquisar'

    expect(page).to have_link 'Suco de Limão'
    expect(page).to have_link 'Suco de Laranja'
  end

  it 'but it only match with other restaurant\'s itens' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    Beverage.create!(name: 'Suco de Limão', description: 'Feito com polpa de limão na hora', is_alcoholic: false,restaurant: restaurant)
    Dish.create!(name: 'hamburger', description: 'vegetariano', restaurant: restaurant)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Jefferson', last_name: 'Aparecido', email: 'jefferson@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Cantinho Nordestino', corporate_name: 'cantinho Nordestino', registration_number: CNPJ.generate, street: 'Avenida das araras', address_number: '342', city: 'São Paulo', state: 'São Paulo', phone_number: '2245894339', email: 'cantinhonordestino@email.com', admin: other_admin)
    Dish.create!(name: 'Acarajé', description: 'extra picante', restaurant: other_restaurant)
    Beverage.create!(name: 'Suco de Açai', description: 'com cobertura extra', is_alcoholic: false ,restaurant: other_restaurant)

    login_as admin, scope: :admin
    visit "/"
    fill_in 'Pesquisar por item', with: 'extra'
    click_on 'Pesquisar'

    expect(page).to have_content 'Resultados da pesquisa'
    expect(page).not_to have_content "Nenhum item com nome ou descrição com 'zark' encontrado"
  end
end