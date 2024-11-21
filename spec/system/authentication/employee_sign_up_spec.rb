require 'rails_helper'

describe 'employee sign up' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    
    visit '/'
    click_on 'funcionário'
    fill_in 'Nome', with: 'Carlos'
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: "carlos@email.com"
    fill_in 'Senha', with: 'senha123senha'
    fill_in 'Confirme sua senha', with: 'senha123senha'
    click_on 'Criar Conta'

    expect(page).to have_content 'Carlos'
    expect(page).to have_content 'Burger King'
    expect(page).not_to have_content 'Itens'
    expect(page).not_to have_content 'Funcionários'
    expect(current_path).to eq menus_path

  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    
    visit '/'
    click_on 'funcionário'
    fill_in 'Nome', with: 'Carlos'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: "carlos@email.com"
    fill_in 'Senha', with: 'senha123senha'
    fill_in 'Confirme sua senha', with: 'senha123senha'
    click_on 'Criar Conta'

    expect(current_path).to eq employee_registration_path
  end
end