require 'rails_helper'

describe 'admin try to create caracteristic' do
  it 'As an admin and succed' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
   
    login_as admin, scope: :admin
    post caracteristics_path, params: {caracteristic: {name: 'Extra Grande'}}
    expect(response).to redirect_to new_item_path
    follow_redirect!
    expect(response.body).to include 'Extra Grande'
  end

  it 'As an Employee and fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    employee = Employee.create!(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    login_as employee, scope: :employee
    post caracteristics_path, params: {caracteristic: {name: 'Extra Grande'}}
    expect(response).to redirect_to new_admin_session_path
    follow_redirect!
    expect(response.body).not_to include 'Extra Grande'
  end

  it 'and fail because its not authenticated' do
    post caracteristics_path, params: {caracteristic: {name: 'Extra Grande'}}
    expect(response).to redirect_to new_admin_session_path
    follow_redirect!
    expect(response.body).not_to include 'Extra Grande'
  end
end