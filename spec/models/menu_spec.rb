require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      menu = Menu.new(name: '', restaurant: restaurant)

      expect(menu.valid?).to eq false
    end

    it 'false when restaurant already has a menu with the same name' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      Menu.create!(name: 'Salgados', restaurant: restaurant)
      menu = Menu.new(name: 'Salgados', restaurant: restaurant)

      expect(menu.valid?).to eq false
    end

    it 'false when start_date or end_date is present and the other not' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      menu1 = Menu.new(name: 'Salgados', restaurant: restaurant, start_date: 1.day.from_now)
      menu2 = Menu.new(name: 'Doces', restaurant: restaurant, end_date: 1.day.from_now)

      expect(menu1.valid?).to eq false
      expect(menu2.valid?).to eq false
    end

    it 'false when start_date is older than current date' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      menu = Menu.new(name: 'Salgados', restaurant: restaurant, start_date: 1.day.ago, end_date: Date.current)

      expect(menu.valid?).to eq false
    end

    it 'false when end date is older or equal start date' do
      admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
      restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
      menu1 = Menu.new(name: 'Salgados', restaurant: restaurant, start_date: 1.day.from_now, end_date: 1.day.from_now)
      menu2 = Menu.new(name: 'Doces', restaurant: restaurant, start_date: 1.day.from_now, end_date: 1.day.ago)

      expect(menu1.valid?).to eq false
      expect(menu2.valid?).to eq false
    end
  end
end
