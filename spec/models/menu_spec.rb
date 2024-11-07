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
  end

  it 'return only active and non removed items' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item1 = Item.create!(name: 'Sorvete de chocolate', description: 'Feito para uma pessoa', restaurant: restaurant)
    item2 = Item.create!(name: 'Sorvete de Menta', description: 'Feito para uma pessoa', restaurant: restaurant, is_active: false)
    item3 = Item.create!(name: 'Sorvete de Morango', description: 'Feito para uma pessoa', restaurant: restaurant, is_removed: true)
    menu = Menu.create!(name: 'Sorvetes', restaurant: restaurant, items: [item1, item2, item3])

    expect(menu.valid_items).to include(item1)
    expect(menu.valid_items).not_to include(item2)
    expect(menu.valid_items).not_to include(item3)
  end
end
