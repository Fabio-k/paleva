require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when cpf is empty' do
          admin = Admin.new(cpf:'', name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

          expect(admin.valid?).to eq false
      end

      it 'false when name is empty' do
        admin = Admin.new(cpf: CPF.generate, name: '', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

        expect(admin.valid?).to eq false
      end
      
      it 'false when last_name is empty' do
        admin = Admin.new(cpf: CPF.generate, name: 'Fabio', last_name: '', email: 'fabio@email.com', password: 'senha1234senha')

        expect(admin.valid?).to eq false
      end
    end
   
    it 'cpf is valid' do 
      admin = Admin.new(cpf:'52252252222', name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

      expect(admin.valid?).to eq false
    end

    it 'false when cpf is not unique' do
      cpf = CPF.generate
      Admin.create!(cpf: cpf, name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')
      other_admin = Admin.new(cpf: cpf, name: 'Roberto', last_name: 'Silva', email: 'Roberto@email.com', password: 'senha1234senha')

      expect(other_admin.valid?).to eq false
    end

    it 'false when there is already a user with email or cpf' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      cpf = CPF.generate
      EmployeePreRegistration.create!(cpf: cpf, email: "carlos@email.com", restaurant: restaurant)
      Employee.create!(name: 'Carlos', email: 'carlos@email.com', password: 'senha123senha', cpf: cpf)
      other_admin = Admin.new(cpf: cpf, name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

      expect(other_admin.valid?).to eq false
    end

  end
end
