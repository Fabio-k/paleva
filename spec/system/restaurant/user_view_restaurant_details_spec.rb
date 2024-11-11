require 'rails_helper'

describe 'user view restaurant details' do
  it 'with success' do
    cnpj = CNPJ.generate
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: cnpj, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    
    login_as admin, scope: :admin
    visit '/'
    click_on 'Burger King'
    
    expect(page).to have_content 'Burger King'
    expect(page).to have_content 'Burger King LTDA'
    expect(page).to have_content cnpj
  end
end