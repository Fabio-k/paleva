require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when cpf is empty' do
          admin = Admin.new(cpf:'', name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

          expect(admin.valid?).to eq false
      end
      it 'false when name is empty' do
        admin = Admin.new(cpf:'54353335335', name: '', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

        expect(admin.valid?).to eq false
      end
      it 'false when last_name is empty' do
        admin = Admin.new(cpf:'54353333333', name: 'Fabio', last_name: '', email: 'fabio@email.com', password: 'senha1234senha')

        expect(admin.valid?).to eq false
      end
    end
   
    it 'cpf is valid' do 
      admin = Admin.new(cpf:'52252252222', name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

      expect(admin.valid?).to eq false
    end
  end
end
