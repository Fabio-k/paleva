require 'rails_helper'

describe 'admin can edit portion' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: dish, description: 'Lasanha para uma pessoa', price: 3240)
    PortionPrice.create!(portion: portion, price: 3240)

    login_as admin
    visit '/'
    click_on 'lasanha'
    within 'section#portion' do
      click_on 'Editar'
    end
    fill_in 'Descrição', with: 'Lasanha para duas pessoas'
    fill_in 'Preço', with: '6480'
    click_on 'Salvar alterações'

    expect(page).to have_content 'lasanha'
    expect(page).to have_content 'Lasanha para duas pessoa'
    expect(page).to have_content 'R$ 32,40'
    expect(page).to have_content 'R$ 64,80'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: dish, description: 'Lasanha para uma pessoa', price: 3240)
    PortionPrice.create!(portion: portion, price: 3240)

    login_as admin
    visit '/'
    click_on 'lasanha'
    within 'section#portion' do
      click_on 'Editar'
    end
    fill_in 'Descrição', with: ''
    fill_in 'Preço', with: ''
    click_on 'Salvar alterações'

    expect(page).to have_content 'Erro ao tentar salvar alterações'
    expect(page).to have_content 'Lasanha para uma pessoa'
    expect(page).to have_content 'R$ 32,40'
  end
end