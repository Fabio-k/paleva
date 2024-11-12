require 'rails_helper'

RSpec.describe Caracteristic, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        caracteristic = Caracteristic.new(name: '', restaurant: restaurant)

        expect(caracteristic.valid?).to eq false
      end 
    end
  end
end
