require 'rails_helper'

RSpec.describe Portion, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when description is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
        dish = Dish.create!(name: 'Feijoada', description: 'feita no forno à lenha', restaurant: restaurant)
        portion = Portion.new(description: '', item: dish)  

        expect(portion.valid?).to eq false
      end

    end
  end

  it 'returns current price' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    dish = Dish.create!(name: 'Feijoada', description: 'feita no forno à lenha', restaurant: restaurant)
    portion = Portion.create!(description: 'Para uma pessoa', item: dish)  
    PortionPrice.create!(price: 1090, portion: portion) 
    PortionPrice.create!(price: 1590, portion: portion) 
    PortionPrice.create!(price: 1950, portion: portion) 

    expect(portion.current_price).to eq 1950
  end
end