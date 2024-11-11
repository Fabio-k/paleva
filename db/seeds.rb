PortionPrice.destroy_all
Portion.destroy_all
ItemCaracteristic.destroy_all
Menu.destroy_all
MenuItem.destroy_all
Item.destroy_all
Employee.destroy_all
EmployeePreRegistration.destroy_all
Order.destroy_all
BusinessHour.destroy_all
Restaurant.destroy_all
Caracteristic.destroy_all
Admin.destroy_all

admin = Admin.find_or_create_by!(cpf: CPF.generate) do |admin|
  admin.name = 'Victor'
  admin.last_name = 'Borges'
  admin.email = 'victor@email.com'
  admin.password = 'senha123senha'
  admin.password_confirmation = 'senha123senha'
end

restaurant = Restaurant.create!(registration_number: CNPJ.generate, brand_name: 'Borges Café', corporate_name: 'Borges ltda', email: 'borgescafe@email.com', phone_number: '11997298767', admin: admin, street: 'Av. Brig. Faria Lima', address_number: '6755', city: 'São Paulo', state: 'São Paulo')
cpf = CPF.generate
EmployeePreRegistration.create!(cpf: cpf, email: 'rafael@email.com', restaurant: restaurant)
Employee.create!(name: 'Rafael', cpf: cpf, email: 'rafael@email.com', password: 'senha123senha')
EmployeePreRegistration.create!(cpf: CPF.generate, email: 'guilherme@email.com', restaurant: restaurant)

items = Item.create!([
  {
    name: 'Pão de queijo',
    description: 'Feito na hora. O melhor pão de queijo mineiro',
    calories: '234',
    restaurant: restaurant,
    type: 'Dish'
  },
  {
    name: 'Suco de Laranja',
    description: 'Suco de laranja natural, feito na hora',
    calories: '120',
    restaurant: restaurant,
    type: 'Beverage'
  },
  {
    name: 'Bolo de Chocolate',
    description: 'Bolo de chocolate com cobertura de brigadeiro',
    calories: '450',
    restaurant: restaurant,
    type: 'Dish'
  },
  {
    name: 'Bolo de Morango',
    description: 'Feito com morangos da região',
    calories: '850',
    restaurant: restaurant,
    type: 'Dish',
    is_active: false
  },
  {
    name: 'Kaiser Bock',
    description: 'A bebida numero um do Brasil',
    calories: '420',
    restaurant: restaurant,
    type: 'Beverage',
    is_removed: true
  }

])

items.each do |item|
  case item.name 
  when 'Pão de queijo'
    item.portions.create(description: '10 unidades', price: 2300)
    item.portions.create(description: '20 unidades', price: 3580)
    item.photo.attach(io: File.open(Rails.root.join('app/assets/images/paodequeijo.jpeg')), filename: 'paodequeijo.jpeg')
  when 'Suco de Laranja'
    item.portions.create(description: '200 ml', price: 1250)
    item.portions.create(description: '350 ml', price: 1875)
    item.caracteristics.create!(name: 'Natural', admin: admin)
    item.photo.attach(io: File.open(Rails.root.join('app/assets/images/sucodelaranja.jpeg')), filename: 'sucodelaranja.jpeg')
  when 'Bolo de Morango'
    item.portions.create(description: '1 fatia', price: 650)
    item.portions.create(description: '2 fatias', price: 1050)
    item.portions.create(description: 'Bolo inteiro', price: 5260)
    item.photo.attach(io: File.open(Rails.root.join('app/assets/images/bolodemorango.jpeg')), filename: 'bolodemorango.jpeg')
  when 'Bolo de Chocolate'
    item.portions.create(description: '1 fatia', price: 450)
    item.portions.create(description: '2 fatias', price: 750)
    item.portions.create(description: 'Bolo inteiro', price: 3660)
    item.photo.attach(io: File.open(Rails.root.join('app/assets/images/bolodechocolate.jpeg')), filename: 'bolodechocolate.jpeg')
  when 'Kaiser Bock'
    item.photo.attach(io: File.open(Rails.root.join('app/assets/images/kaiserbock.jpeg')), filename: 'kaiserbock.jpeg')
  end
  sleep(0.1) # evitar deadlock
end

["Salgados", "Bebidas", "Sobremesas"].each do |name|
  Menu.find_or_create_by!(name: name, restaurant: restaurant)
end