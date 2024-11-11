require 'rails_helper'

describe 'admin create a beverage' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin, scope: :admin
    visit "/"
    within 'nav' do
      click_on 'Itens'
    end
    
    click_on 'Adicionar Item'
    
    select 'Bebida', from: 'item_type_select'
    within 'div#item_name' do
      fill_in 'Nome', with: 'Suco de limão'
    end
    fill_in 'Descrição', with: 'Feito na hora'
    attach_file 'item_photo', Rails.root.join('spec', 'support', 'sucodelimao.jpeg')
    click_on 'Adicionar Item'

    expect(page).to have_content 'Suco de limão'
    expect(page).to have_css 'img[src*="sucodelimao.jpeg"]'
    expect(page).to have_content 'Feito na hora'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin, scope: :admin
    visit new_item_path
    within 'div#item_name' do
      fill_in 'Nome', with: ''
    end
    fill_in 'Descrição', with: ''
    click_on 'Adicionar Item'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end