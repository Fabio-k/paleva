require 'rails_helper'

describe 'user register a portion' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    login_as admin, scope: :admin
    visit '/' 
    within 'nav' do
      click_on 'Itens'
    end
    click_on 'Adicionar Porção'
    fill_in 'Descrição', with: 'Lasanha de queijo'
    fill_in 'Preço', with: '1050'
    click_on 'Criar Porção'

    expect(page).to have_content 'Lasanha de queijo'
    expect(page).to have_content 'R$ 10,50'
  end

  it 'with failed' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)

    login_as admin, scope: :admin
    visit new_item_portion_path(item.id)
    fill_in 'Descrição', with: 'Lasanha de queijo'
    fill_in 'Preço', with: ''
    click_on 'Criar Porção'

    expect(page).not_to have_content 'Lasanha de queijo'
    expect(page).not_to have_content 'R$ 10,50'
    expect(page).to have_content 'Erro ao tentar salvar a porção'
  end
end