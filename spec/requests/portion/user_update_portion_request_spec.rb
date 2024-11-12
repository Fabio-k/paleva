require 'rails_helper'

describe 'user try to update portion' do
  it 'As an admin an succed' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create(description: 'Para uma pessoa', price: 2340, item: dish)

    login_as admin, scope: :admin
    patch portion_path(portion.id), params: {portion: {price: 2670}}
    follow_redirect!
    expect(response.body).not_to include 'Erro ao tentar salvar alterações'
    expect(response.body).to include 'Para uma pessoa' 
  end

  it 'As an employee and fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create(description: 'Para uma pessoa', price: 2340, item: dish)

    cpf = CPF.generate
    EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
    employee = Employee.create!(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)

    login_as employee, scope: :employee
    patch portion_path(portion.id), params: {portion: {price: 2670}}

    expect(response).to redirect_to new_admin_session_path
  end

  it 'fail because its not authenticated' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create(description: 'Para uma pessoa', price: 2340, item: dish)

    patch portion_path(portion.id), params: {portion: {price: 2670}}

    expect(response).to redirect_to new_admin_session_path
  end

  it 'fail because admin dont own item' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
      
    other_admin = Admin.create!(cpf: CPF.generate, name: 'Ronaldo', last_name: 'Ferreira', email: 'ronaldo@email.com', password: 'senha123senha')
    other_restaurant = Restaurant.create!(brand_name: 'Sr. Marmita', corporate_name: 'Sr. Marmita LTDA', registration_number: CNPJ.generate, street: 'Avenida das bandeiras', address_number: '334', city: 'Poa', state: 'São Paulo', phone_number: '1177897548', email: 'srmarmita@email.com', admin: other_admin)
    beverage = Beverage.create!(name: 'Suco de melancia', description: 'feito na hora', is_alcoholic: false, restaurant: other_restaurant)
    portion = Portion.create(description: 'Para uma pessoa', price: 2340, item: beverage)

    login_as admin, scope: :admin
    patch portion_path(portion.id), params: {portion: {price: 2670}}
    
    expect(response).to redirect_to menus_path
    follow_redirect!
    expect(response.body).to include 'Porção não encontrada'
  end
end