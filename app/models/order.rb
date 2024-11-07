class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_items
  has_many :items, through: :order_items

  validates :client_name, :cpf, presence: true

  validate :valid_email_or_valid_phone_number_should_be_present
  validate :cpf_should_be_valid

  before_validation :generate_code, on: :create

  enum :status, {:wainting_confirmation=>0, :in_progress=>2, :canceled=>4, :ready=>6, :delivered=>8}

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8)
  end

  def valid_email_or_valid_phone_number_should_be_present
    unless self.phone_number? || self.email.present?
      return errors.add(:phone, 'ou E-mail deve estar presente')
    end
    
    if self.email.present? && !self.email.match(/\A[^@\s]+@[^@\s]+\z/)
      errors.add(:email, 'deve ser válido')
    end

    if self.phone_number.present? && !(10..11).include?(self.phone_number.length)
      errors.add(:phone_number, 'deve possuir 10 ou 11 caracters')
    end 
  end

  def cpf_should_be_valid
    if self.cpf.present? 
       unless CPF.valid?(self.cpf)
         errors.add(:cpf, 'deve ser válido')
       end
    end
  end
end
