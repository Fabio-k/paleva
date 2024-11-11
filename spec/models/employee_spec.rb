require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        cpf = CPF.generate
        EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
        employee = Employee.new(name: '', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)
        
        expect(employee.valid?).to eq false
      end

      it 'false when cpf is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        cpf = CPF.generate
        EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
        employee = Employee.new(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: '')

        expect(employee.valid?).to eq false
      end

    end

    it 'false when cpf is not valid' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        cpf = CPF.generate
        EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
        employee = Employee.new(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: 'sdf432')
        
        expect(employee.valid?).to eq false
    end
  end
end
