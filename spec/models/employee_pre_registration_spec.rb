require 'rails_helper'

RSpec.describe EmployeePreRegistration, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when cpf is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        emp_pre_r = EmployeePreRegistration.new(cpf: '', email: "carlos@email.com", restaurant: restaurant)
        
        expect(emp_pre_r.valid?).to eq false
      end

      it 'false when email is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        cpf = CPF.generate
        emp_pre_r = EmployeePreRegistration.new(cpf: cpf, email: "", restaurant: restaurant)

        expect(emp_pre_r.valid?).to eq false
      end
    end

    it 'false when cpf is not valid' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        emp_pre_r = EmployeePreRegistration.new(cpf: 'sf932', email: "carlos@email.com", restaurant: restaurant)

        expect(emp_pre_r.valid?).to eq false
    end

    it 'false when e-mail is not valid' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        emp_pre_r = EmployeePreRegistration.new(cpf: 'sf932', email: "carlosemail.com", restaurant: restaurant)

        expect(emp_pre_r.valid?).to eq false
    end

    it 'false when there is already a user with email or cpf' do
      cpf = CPF.generate
      admin = Admin.create!(cpf: cpf, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      emp_pre_r = EmployeePreRegistration.new(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)

      expect(emp_pre_r.valid?).to eq false
    end

    it 'false when there is already a pre registration with cpf or email' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      cpf = CPF.generate
      EmployeePreRegistration.create!(cpf: cpf, email: "rodolfo@email.com", restaurant: restaurant)
      EmployeePreRegistration.create!(cpf: CPF.generate, email: "Goku@email.com", restaurant: restaurant)
      emp_pre_r_same_cpf = EmployeePreRegistration.new(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
      emp_pre_r_same_email = EmployeePreRegistration.new(cpf: CPF.generate, email: "Goku@email.com", restaurant: restaurant)

      expect(emp_pre_r_same_cpf.valid?).to eq false
      expect(emp_pre_r_same_email.valid?).to eq false
    end

  end
end
