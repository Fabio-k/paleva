require 'rails_helper'

describe 'user visit homepage' do
  it 'and should be authenticated' do
    visit root_path

    expect(current_path).to eq new_admin_session_path
  end
end