require 'rails_helper'

describe 'admin register restaurant' do
  it 'with success' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')

    login_as admin, scope: :admin
    visit '/'
    fill_in 'Nome fantasia', with: 'Djapa'
    fill_in 'Razão social', with: 'Djapa'
    fill_in 'CNPJ', with: CNPJ.generate
    fill_in 'Rua', with: 'Av. Cap. Manoel Rudge'
    fill_in 'Numero', with: '1170'
    fill_in 'Cidade', with: 'Mogi das Cruzes'
    fill_in 'Estado', with: 'São Paulo'
    fill_in 'Numero de telefone', with: '1194438510'
    fill_in 'E-mail', with: 'Djapa@email.com'
    click_on 'Cadastrar'

    admin.reload

    expect(page).to have_content 'Adicionar Horário'
    expect(admin.restaurant.nil?).to eq false
  end

  it 'with fail' do
    admin = Admin.create!(cpf: CPF.generate, name: 'Sergio', last_name: 'Oliveira', email: 'sergio@email.com', password: 'senha123senha')

    login_as admin, scope: :admin
    visit new_restaurant_path
    fill_in 'Nome fantasia', with: ''
    fill_in 'Razão social', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Erro ao cadstrar Restaurante'
  end
end