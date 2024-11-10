require 'rails_helper'

describe 'user create a employee pre registration' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    cpf = CPF.generate
    login_as admin, scope: :admin
    visit '/'
    click_on 'Funcionários'
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: 'rodolfo@email.com'
    click_on 'Cadastrar'

    expect(page).to have_content cpf
    expect(page).to have_content 'rodolfo@email.com'
    expect(page).to have_content 'Não usado'
  end 
end