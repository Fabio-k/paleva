require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when cpf is empty' do
          admin = Admin.new(cpf:'', name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

          expect(admin.valid?).to eq false
      end

      it 'false when name is empty' do
        admin = Admin.new(cpf: CPF.generate, name: '', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

        expect(admin.valid?).to eq false
      end
      
      it 'false when last_name is empty' do
        admin = Admin.new(cpf: CPF.generate, name: 'Fabio', last_name: '', email: 'fabio@email.com', password: 'senha1234senha')

        expect(admin.valid?).to eq false
      end
    end
   
    it 'cpf is valid' do 
      admin = Admin.new(cpf:'52252252222', name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')

      expect(admin.valid?).to eq false
    end

    it 'false when cpf is not unique' do
      cpf = CPF.generate
      Admin.create!(cpf: cpf, name: 'Fabio', last_name: 'Guti', email: 'fabio@email.com', password: 'senha1234senha')
      other_admin = Admin.new(cpf: cpf, name: 'Roberto', last_name: 'Silva', email: 'Roberto@email.com', password: 'senha1234senha')

      expect(other_admin.valid?).to eq false
    end
  end
end
