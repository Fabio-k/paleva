require 'rails_helper'

describe 'user sign in' do
  it 'with success' do
    Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    
    visit root_path
    fill_in 'E-mail', with: 'Roberto@email.com'
    fill_in 'Senha', with: 'senha123senha'
    click_on 'Entrar'

    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content 'Roberto'
  end
  
  it 'and do logout' do
    Admin.create!(cpf: CPF.generate, name: 'Roberto', last_name: 'Carlos', email: 'Roberto@email.com', password: 'senha123senha')
    
    visit root_path
    fill_in 'E-mail', with: 'Roberto@email.com'
    fill_in 'Senha', with: 'senha123senha'
    click_on 'Entrar'

    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end