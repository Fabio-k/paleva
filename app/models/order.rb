class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_portions
  has_many :portions, through: :order_portions

  validates :client_name, :cpf, presence: true

  validate :valid_email_or_valid_phone_number_should_be_present
  validate :cpf_should_be_valid
  validate :cancelled_order_should_have_reason_message
  validate :cannot_change_status_if_ready

  before_validation :generate_code, on: :create

  enum :status, {:wainting_confirmation=>0, :in_progress=>2, :canceled=>4, :ready=>6, :delivered=>8}

  def calculate_total
   self.total_price = self.order_portions.includes(:portion).sum {|order_portion| order_portion.price * order_portion.quantity}
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

  def cancelled_order_should_have_reason_message
    if self.status == 'canceled' && self.reason_message.blank?
      errors.add(:reason_message, 'razão para o cancelamento deve ser obrigatório')
    end
  end

  def cannot_change_status_if_ready
    if status_changed? && self.status_was == 'ready'
      errors.add(:status, 'não pode ser alterado quando está pronto')
    end
  end

  def cannot_accept_if_its_already_accepted
    if self.status == 'in_progress' && !self.status_was == 'wainting_confirmation'
      errors.add(:status, 'não pode aceitar um pedido que já foi aceito')
    end
  end

  scope :visible_status_to_client, -> {where.not(status: 'canceled')}
end
