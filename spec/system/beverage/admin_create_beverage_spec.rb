require 'rails_helper'

describe 'admin create a beverage' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin
    visit "/"
    click_on 'Adicionar Bebida'
    fill_in 'Nome', with: 'Suco de limão'
    fill_in 'Descrição', with: 'Feito na hora'
    check 'Alcólico'
    attach_file 'Foto da Bebida', Rails.root.join('spec', 'support', 'sucodelimao.jpeg')
    click_on 'Adicionar Bebida'

    expect(page).to have_content 'Suco de limão'
    expect(page).to have_css 'img[src*="sucodelimao.jpeg"]'
    expect(page).to have_content 'Feito na hora'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin
    visit "/"
    click_on 'Adicionar Bebida'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    click_on 'Adicionar Bebida'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end