class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, :name, :last_name, presence: true
  validates :cpf, uniqueness: true
  validate :valid_cpf

  has_one :restaurant
  has_many :caracteristics

  private

  def valid_cpf
    if self.cpf.present? && !CPF.valid?(self.cpf)
      errors.add(:cpf, 'deve ser válido')
    end
  end
end
