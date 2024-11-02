require 'rails_helper'

RSpec.describe PortionPrice, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when price is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        dish = Dish.new(name: 'Feijoada', description: '', restaurant: restaurant)
        portion = Portion.new(description: 'Para 1 pessoa', item: dish)  
        portion_price = PortionPrice.new(price: '', portion: portion) 

        expect(portion_price.valid?).to eq false
      end
    end

    it 'show formatted price price' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      dish = Dish.new(name: 'Feijoada', description: '', restaurant: restaurant)
      portion = Portion.new(description: 'Para 1 pessoa', item: dish)  
      portion_price = PortionPrice.new(price: 1090, portion: portion) 
      second_portion_price = PortionPrice.new(price: 90, portion: portion) 

      expect(portion_price.show_price).to eq 'R$ 10,90'
      expect(second_portion_price.show_price).to eq 'R$ 0,90'
    end
  end
end
