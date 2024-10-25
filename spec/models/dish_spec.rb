require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        dish = Dish.new(name: '', description: 'Feijão preto cozido com carnes suínas e bovinas, servido com arroz branco, couve refogada, farofa crocante e fatias de laranja. Um clássico brasileiro, perfeito para momentos especiais.')
        
        expect(dish.valid?).to eq false
      end

      it 'false when description is empty' do
        dish = Dish.new(name: 'Feijoada', description: '')
        
        expect(dish.valid?).to eq false
      end
    end
  end
end
