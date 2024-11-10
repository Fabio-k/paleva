require 'rails_helper'

describe 'admin register a caracteristic' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin, scope: :admin
    visit '/'
    within 'nav' do
      click_on 'itens'
    end
    within 'section#menu_Item' do
      click_on 'Adicionar Item'
    end
    within 'div#caracteristic' do
      fill_in 'Nome', with: 'Picante'
      click_on 'Adicionar característica'
    end
    within 'div#item_name' do
      fill_in 'Nome', with: 'Lasanha'
    end
    fill_in 'Descrição', with: 'Camadas de massa intercaladas com molho bolonhesa, molho bechamel e queijo derretido.'
    check 'Picante'
    click_on 'Adicionar Item'

    expect(page).to have_content '#Picante'
  end

  it 'and cant see other admin\'s caracteristics' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Caracteristic.create!(name: 'Picante', admin: admin)

    other_admin = Admin.create!(cpf: CPF.generate, name: 'Link', last_name: 'Hyrule', email: 'link@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Hyrulian Cafe', corporate_name: 'Hyrulian LTDA', registration_number: CNPJ.generate, street: 'Avenida korok street', address_number: '222', city: 'Hyrule', state: 'Hyrule', phone_number: '1111122200', email: 'hyrulecafe@email.com', admin: other_admin)
    Caracteristic.create!(name: '4 hearts', admin: other_admin)

    login_as admin, scope: :admin
    visit new_item_path

    expect(page).to have_content 'Picante'
    expect(page).not_to have_content '4 hearts'
  end
end