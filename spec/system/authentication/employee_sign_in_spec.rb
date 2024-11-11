require 'rails_helper'

describe 'employee sign_in' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    Employee.create!(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    visit '/'
    click_on 'Entrar'
    click_on 'funcionário'
    fill_in 'E-mail', with: 'carlos@email.com'
    fill_in 'Senha', with: 'senha123senha'
    click_on 'Entrar'

    expect(page).to have_content 'Burger King'
    expect(page).to have_content 'Carlos'
    expect(page).not_to have_content 'Itens'
    expect(page).not_to have_link 'Editar Cardápio'
  end

  it 'and do logout' do
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
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso'
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    Employee.create!(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    visit '/'
    click_on 'Entrar'
    click_on 'funcionário'
    fill_in 'E-mail', with: 'carlos@email.com'
    fill_in 'Senha', with: 'senha123'
    click_on 'Entrar'

    expect(page).to have_content 'E-mail ou senha inválidos.'
  end
end