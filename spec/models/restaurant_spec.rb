require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when brand_name is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: '', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when corporate_name is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: '', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when registration_number is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: '', street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when street is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: '', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when address_number is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when city is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: '', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when state is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: '', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when phone_number is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '', email: 'burgerking@email.com', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end

      it 'false when email is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: '', admin: admin)
        
        expect(restaurant.valid?).to eq false
      end
    end

    it 'Registration_number is false when it is not a valid registration_number' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: '3252523', street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
        
      expect(restaurant.valid?).to eq false
    end

    it 'email is false when it is not a valid email' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.new(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgeremail.com', admin: admin)
        
      expect(restaurant.valid?).to eq false
    end
  end

  it 'generates a random code' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)

    expect(restaurant.code.length).to eq 6
  end

  it 'code is unique' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
    other_restaurant = Restaurant.create!(brand_name: 'Subway', corporate_name: 'Subway LTDA', registration_number: CNPJ.generate, street: 'Avenida Flávio Melo', address_number: '242', city: 'São Paulo', state: 'São Paulo', phone_number: '1145903221', email: 'subway@email.com', admin: admin)

    expect(restaurant.code).not_to eq other_restaurant.code
  end
end
