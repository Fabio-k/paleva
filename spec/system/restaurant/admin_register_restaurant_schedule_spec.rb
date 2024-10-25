require 'rails_helper'

describe 'user register restaurant schedule' do
  it 'should be authenticated' do
    visit business_hours_path
    expect(current_path).to eq new_admin_session_path
  end

  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin
    visit business_hours_path
    select 'Terça', from: 'Dia da semana'
    fill_in 'Abre as', with: '10:50'
    fill_in 'Fecha as', with: '18:30'
    click_on 'Adicionar'

    expect(page).to have_content '10:50'
    expect(page).to have_content '18:30'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    login_as admin
    visit business_hours_path
    select 'Terça', from: 'Dia da semana'
    fill_in 'Abre as', with: '10:50'
    click_on 'Adicionar'

    expect(page).to have_content ''
    expect(page).not_to have_content '10:50'
  end
end