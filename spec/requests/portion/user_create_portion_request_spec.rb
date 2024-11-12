require 'rails_helper'

describe 'user try to create a portion' do
  it 'As admin and succed' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
      
    login_as admin, scope: :admin
    post item_portions_path(dish.id), params: {description: 'Para uma pessoa', price: 2340}
    expect(response).to redirect_to item_path(dish.id)
    follow_redirect!
    expect(response.body).to include 'Para uma pessoa'
  end

  it 'As an employee and fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    employee = Employee.create!(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    login_as employee, scope: :employee
    post item_portions_path(dish.id), params: {description: 'Para uma pessoa', price: 2340}
    expect(response).to redirect_to new_admin_session_path
    follow_redirect!
    expect(response.body).to include 'Para continuar, faça login ou registre-se'
  end

  it 'and fail because its not authenticated' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
   
    post item_portions_path(dish.id), params: {description: 'Para uma pessoa', price: 2340}
    expect(response).to redirect_to new_admin_session_path
    follow_redirect!
    expect(response.body).to include 'Para continuar, faça login ou registre-se'
  end

  it 'and fail because admin dont own item' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
      
    other_admin = Admin.create!(cpf: CPF.generate, name: 'Ronaldo', last_name: 'Ferreira', email: 'ronaldo@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Sr. Marmita', corporate_name: 'Sr. Marmita LTDA', registration_number: CNPJ.generate, street: 'Avenida das bandeiras', address_number: '334', city: 'Poa', state: 'São Paulo', phone_number: '1177897548', email: 'srmarmita@email.com', admin: other_admin)
    beverage = Beverage.create!(name: 'Suco de melancia', description: 'feito na hora', is_alcoholic: false, restaurant: other_restaurant)

    login_as admin, scope: :admin
    post item_portions_path(beverage.id), params: {description: 'Para uma pessoa', price: 2340}
    expect(response).to redirect_to menus_path
  end
end