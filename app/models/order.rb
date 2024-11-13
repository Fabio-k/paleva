class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_portions
  has_many :portions, through: :order_portions

  validates :client_name, :cpf, presence: true

  validate :valid_email_or_valid_phone_number_should_be_present
  validate :cpf_should_be_valid

  before_validation :generate_code, on: :create

  enum :status, {:wainting_confirmation=>0, :in_progress=>2, :canceled=>4, :ready=>6, :delivered=>8}

  def calculate_total
   self.total_price = self.order_portions.includes(:portion).sum {|order_portion| order_portion.price}
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
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
