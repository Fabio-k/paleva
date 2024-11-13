class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, :name, :last_name, presence: true
  validates :cpf, uniqueness: true
  validate :valid_cpf
  validate :email_cpf_should_be_unique

  has_one :restaurant
  

  private

  def email_cpf_should_be_unique
    return unless self.email.present? || self.cpf.present?
    if email_exist? 
      erros.add(:email, "Deve ser único")
    end
    if cpf_exist?
      errors.add(:cpf, "Deve ser único")
    end
  end

  def email_exist?
    Admin.find_by(email: self.email).present? || Employee.find_by(email: self.email).present?
  end

  def cpf_exist?
    Admin.find_by(cpf: self.cpf).present? || Employee.find_by(cpf: self.cpf).present?
  end

  def valid_cpf
    if self.cpf.present? && !CPF.valid?(self.cpf)
      errors.add(:cpf, 'deve ser válido')
    end
  end
end
