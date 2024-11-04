require 'rails_helper'

RSpec.describe Caracteristic, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        caracteristic = Caracteristic.new(name: '')

        expect(caracteristic.valid?).to eq false
      end 
    end
  end
end
