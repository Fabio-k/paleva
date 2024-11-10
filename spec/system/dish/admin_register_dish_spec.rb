require 'rails_helper'

describe 'admin register a dish' do
  it 'and should be authenticated' do
    visit new_item_path

    expect(current_path).to eq new_admin_session_path
  end

  it 'and should be associated with a restaurant' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')

    login_as admin, scope: :admin
    visit new_item_path

    expect(current_path).to eq new_restaurant_path
  end

  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin, scope: :admin
    visit "/"
    within 'nav' do
      click_on 'itens'
    end
    within 'section#menu_Item' do
      click_on 'Adicionar Item'
    end
    within 'div#item_name' do
       fill_in 'Nome', with: 'Lasanha'
    end
    fill_in 'Descrição', with: 'Camadas de massa intercaladas com molho bolonhesa, molho bechamel e queijo derretido.'
    fill_in 'Calorias', with: '1400'
    attach_file 'Foto do prato', Rails.root.join('spec', 'support', 'lasanhadequeijo.jpeg')
    click_on 'Adicionar Item'

    expect(page).to have_content 'Lasanha'
    expect(page).to have_content 'Camadas de massa intercaladas com molho bolonhesa, molho bechamel e queijo derretido.'
    expect(page).to have_css 'img[src*="lasanhadequeijo.jpeg"]'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin, scope: :admin
    visit new_item_path
    within 'div#item_name' do
       fill_in 'Nome', with: ''
    end
    fill_in 'Descrição', with: 'Camadas de massa intercaladas com molho bolonhesa, molho bechamel e queijo derretido.'
    fill_in 'Calorias', with: '1400'
    attach_file 'Foto do prato', Rails.root.join('spec', 'support', 'lasanhadequeijo.jpeg')
    click_on 'Adicionar Item'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end