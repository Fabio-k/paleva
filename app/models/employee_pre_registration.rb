class EmployeePreRegistration < ApplicationRecord
  belongs_to :restaurant

  validates :cpf, :email, uniqueness: true 
  validate :valid_cpf
  validate :valid_email

  private

  def valid_cpf
    if self.cpf.present? && !CPF.valid?(self.cpf)
      errors.add(:cpf, 'deve ser válido')
    end
  end

  def valid_email
    if self.email.present? && !self.email.match(/\A[^@\s]+@[^@\s]+\z/)
      errors.add(:email, 'deve ser válido')
    end
  end
end
