require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when client_name is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

        order = Order.new(cpf: CPF.generate, client_name: '', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
      
        expect(order.valid?).to eq false
      end

      it 'false when cpf is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

        order = Order.new(cpf: '', client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
      
        expect(order.valid?).to eq false
      end

      it 'false when email and phone_number is empty' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

        order = Order.new(cpf: CPF.generate, client_name: 'client', phone_number: '', email: '', restaurant: restaurant)
      
        expect(order.valid?).to eq false
      end

      it 'true when email is present' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

        order = Order.new(cpf: CPF.generate, client_name: 'client', phone_number: '', email: 'client@email.com', restaurant: restaurant)
      
        expect(order.valid?).to eq true
      end

      it 'true when phone_number is present' do
        admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
        restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

        order = Order.new(cpf: CPF.generate, client_name: 'client', phone_number: '11473832330', email: '', restaurant: restaurant)
      
        expect(order.valid?).to eq true
      end
    end

    it 'false when email is not valid' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

      order = Order.new(cpf: CPF.generate, client_name: 'client', phone_number: '11473832330', email: 'client.com', restaurant: restaurant)
    
      expect(order.valid?).to eq false
    end

    it 'false when phone_number is not in range 10..11' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

      order = Order.new(cpf: CPF.generate, client_name: 'client', phone_number: '114738323', email: 'client@email.com', restaurant: restaurant)
      order2 = Order.new(cpf: CPF.generate, client_name: 'client', phone_number: '114738323300', email: 'client@email.com', restaurant: restaurant)
    
      expect(order.valid?).to eq false
      expect(order2.valid?).to eq false
    end

    it 'false when status is cancelled and reason_message is empty' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

      order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '11473832330', email: 'client@email.com',restaurant: restaurant)
      status = order.order_statuses.new(status: :canceled)
      expect(status.valid?).to eq false
    end
  end

  it 'generates a code' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '1147383233', email: 'client@email.com', restaurant: restaurant)

    expect(order.code.length).to eq 8
  end

  it 'code is unique' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)

    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '1147383233', email: 'client@email.com', restaurant: restaurant)
    order2 = Order.create!(cpf: CPF.generate, client_name: 'Ash Ketchum', phone_number: '1147383343', email: 'ash@email.com', restaurant: restaurant)

    expect(order.code).not_to eq order2.code
  end

  it 'calculate total price based on the price at the time of creation' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa', price: 3240)
    PortionPrice.create!(portion: portion, price: 3240)

    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)
    order.order_statuses.create!

    portion.update(price: 4549)

    expect(order.calculate_total).to eq 3240
  end

  it 'with status ready cant be changed to in_progress' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item = Dish.create!(name: 'lasanha', description: 'Lasanha de queijo com abóbora', restaurant: restaurant)
    portion = Portion.create!(item: item, description: 'Lasanha para uma pessoa', price: 3240)
    PortionPrice.create!(portion: portion, price: 3240)

    order = Order.create!(cpf: CPF.generate, client_name: 'client', phone_number: '24589332110', email: 'client@gmail.com', restaurant: restaurant)
    order.order_portions.create!(note: 'Não adicionar azeitona', quantity: 1, portion: portion)
    order.order_statuses.create!(status: :ready)

    status = order.order_statuses.create(status: :wainting_confirmation)

    expect(status.persisted?).to eq false
  end

end
