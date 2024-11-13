class Restaurant < ApplicationRecord
  belongs_to :admin
  has_many :business_hours
  has_many :items
  has_many :portions, through: :items
  has_many :menus
  has_many :employee_pre_registrations
  has_many :caracteristics
  has_many :orders
  
  validates :brand_name, :corporate_name, :registration_number, :street, :address_number, :city, :state, :phone_number, :email, presence: true
  validates :phone_number, length: {in: 10..11}
  validates :email, format: {with: /\A[^@\s]+@[^@\s]+\z/}
  validates :admin, uniqueness: true 
  validate :valid_registration_number

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

  def valid_registration_number
    if self.registration_number.present? && !CNPJ.valid?(self.registration_number)
      errors.add(:registration_number, 'precisa ser válido')
    end
  end
  
end
