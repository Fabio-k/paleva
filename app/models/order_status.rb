class OrderStatus < ApplicationRecord
  belongs_to :order
  enum :status, {:wainting_confirmation=>0, :in_progress=>2, :canceled=>4, :ready=>6, :delivered=>8}

  validate :cancelled_order_should_have_reason_message
  validate :cannot_change_status_if_ready_or_canceled

  private

  def cancelled_order_should_have_reason_message
    if self.status == 'canceled' && self.order.reason_message.blank?
      errors.add(:reason_message, 'razão para o cancelamento deve ser obrigatório')
    end
  end

  def cannot_change_status_if_ready_or_canceled
    if order.order_statuses.present? && order.current_status == 'ready'
      errors.add(:status, 'não pode ser alterado quando está pronto ou cancelado')
    end
  end

end
