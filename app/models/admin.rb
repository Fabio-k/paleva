class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, :name, :last_name, presence: true
  validate :valid_cpf

  private

  def valid_cpf
    if self.cpf.present? && !CPF.valid?(self.cpf)
      errors.add(:cpf, 'deve ser válido')
    end
  end
end
