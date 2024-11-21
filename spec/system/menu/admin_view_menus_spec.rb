require 'rails_helper'

describe 'user try to view menus' do
  it 'As an admin and can see menus out of period' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    Menu.create!(name: 'Sobremesas', restaurant: restaurant)
    Menu.create!(name: 'Lanches', restaurant: restaurant, start_date: 1.day.from_now, end_date: 2.day.from_now)
    Menu.new(name: 'Sucos do mes', restaurant: restaurant, start_date: 30.day.ago, end_date: 10.day.ago).save(validate: false)

    login_as admin, scope: :admin
    visit '/'
    expect(page).to have_content 'Sobremesas'
    expect(page).to have_content 'Lanches'
    expect(page).to have_content 'Sucos do mes'
  end


  it 'As an employee and cannot see form to create a new menu and link to edit menu' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    employee = Employee.create!(name: 'carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    Menu.create!(name: 'Sobremesas', restaurant: restaurant)

    login_as employee, scope: :employee
    visit '/'

    expect(page).not_to have_content 'Adicionar Cardápio'
    expect(page).not_to have_button '+'
    expect(page).not_to have_link 'Editar'
  end

  it 'As an employee and cant see menu with ended period or that did not started' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    employee = Employee.create!(name: 'carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    Menu.create!(name: 'Sobremesas', restaurant: restaurant)
    Menu.create!(name: 'Lanches', restaurant: restaurant, start_date: 1.day.from_now, end_date: 2.day.from_now)
    Menu.new(name: 'Sucos do mes', restaurant: restaurant, start_date: 30.day.ago, end_date: 10.day.ago).save(validate: false)



    login_as employee, scope: :employee
    visit '/'
    expect(page).to have_content 'Sobremesas'
    expect(page).not_to have_content 'Lanches'
    expect(page).not_to have_content 'Sucos do mes'
  end
end