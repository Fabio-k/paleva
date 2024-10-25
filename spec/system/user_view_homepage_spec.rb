require 'rails_helper'

describe 'user visit homepage' do
  it 'and can go to login page' do
    visit root_path
    click_on 'Entrar'

    expect(current_path).to eq new_admin_session_path
  end
end