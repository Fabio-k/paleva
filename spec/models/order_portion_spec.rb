require 'rails_helper'

RSpec.describe OrderPortion, type: :model do
  describe '#valid?' do
    context 'comparison' do
        it 'false when quantity is lower than 0' do
          admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
          restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
          item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
          portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa')
          PortionPrice.create!(portion: portion, price: 3240)
          order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
          order_portion = OrderPortion.new(order: order, note: 'Não adicionar azeitona', quantity:  -1, portion: portion)
        
          expect(order_portion.valid?).to eq false
        end
    end
  end
end
