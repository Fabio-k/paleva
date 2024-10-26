require 'rails_helper'

RSpec.describe Beverage, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
        beverage = Beverage.new(name: '', description: 'Feito com polpa de laranja na hora', is_alcoholic: false, restaurant: restaurant)

        expect(beverage.valid?).to eq false
      end

      it 'false when description is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burger@email.com', admin: admin)
        beverage = Beverage.new(name: 'Suco de Laranja', description: '', is_alcoholic: false, restaurant: restaurant)

        expect(beverage.valid?).to eq false
      end
    end
  end
end
