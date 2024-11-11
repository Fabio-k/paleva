class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  belongs_to :restaurant
  validates :name, :cpf, presence: true
  validate :email_cpf_should_be_unique
  before_validation :search_employee_pre_registration, on: :create

  private

  def search_employee_pre_registration
    return unless self.name.present? || self.cpf.present? || self.restaurant.present?
    pre_registration = EmployeePreRegistration.find_by(email: self.email, cpf: self.cpf)
    if pre_registration
      self.restaurant = pre_registration.restaurant
      pre_registration.is_used = true
      pre_registration.save
    else
      errors.add(:restaurant, "consulte se os dados batem com os dados fornecidos pelo seu adiministrador")
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
