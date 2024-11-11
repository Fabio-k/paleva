class EmployeePreRegistration < ApplicationRecord
  belongs_to :restaurant

  validates :cpf, :email, uniqueness: true 
  validates :cpf, :email, presence: true
  validate :valid_cpf
  validate :valid_email
  validate :email_cpf_should_be_unique

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
end
