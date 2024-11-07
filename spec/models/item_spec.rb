require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'return active and non removed items' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')
    restaurant = Restaurant.create!(brand_name: 'Burger King', corporate_name: 'Burger King LTDA', registration_number: CNPJ.generate, street: 'Avenida cívica', address_number: '103', city: 'Mogi das Cruzes', state: 'São Paulo', phone_number: '1197894339', email: 'burgerking@email.com', admin: admin)
    item1 = Item.create!(name: 'Sorvete de chocolate', description: 'Feito para uma pessoa', restaurant: restaurant)
    item2 = Item.create!(name: 'Sorvete de Menta', description: 'Feito para uma pessoa', restaurant: restaurant, is_active: false)
    item3 = Item.create!(name: 'Sorvete de Morango', description: 'Feito para uma pessoa', restaurant: restaurant, is_removed: true)

    expect(Item.all.valid).to include(item1)
    expect(Item.all.valid).not_to include(item2)
    expect(Item.all.valid).not_to include(item3)
  end
end
