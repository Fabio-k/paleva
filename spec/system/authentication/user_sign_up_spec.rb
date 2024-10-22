require 'rails_helper'

describe 'user sign up' do
  it 'with success' do
    visit root_path 
    click_on 'Criar Conta'
    fill_in 'CPF', with: CPF.generate
    fill_in 'Nome', with: 'William'
    fill_in 'Sobrenome', with: 'Daniel'
    fill_in 'E-mail', with: 'william@email.com'
    fill_in 'Senha', with: 'senha1234senha'
    fill_in 'Confirme sua senha', with: 'senha1234senha'
    click_on 'Criar Conta'

    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(current_path).to eq root_path
  end

  it 'with fail' do
    visit root_path 
    click_on 'Criar Conta'
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    click_on 'Criar Conta'

    expect(page).to have_content 'Não foi possível criar dono de restaurante'
  end
end