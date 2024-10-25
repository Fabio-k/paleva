require 'rails_helper'

describe 'admin sign in' do
  it 'with success' do
    Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'Roberto@email.com'
    fill_in 'Senha', with: 'senha123senha'
    click_on 'Entrar'

    expect(page).not_to have_button 'Sair'
    expect(page).to have_content 'Cadastrar Restaurante'
  end
  
  it 'and do logout' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'Roberto@email.com'
    fill_in 'Senha', with: 'senha123senha'
    click_on 'Entrar'

    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end