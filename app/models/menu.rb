class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items
  has_many :items, through: :menu_items
  validates :name, presence: true 
  validate :menu_should_be_unique_for_restaurant, on: [:create, :update]
  validate :dates_presence
  validate :start_date_should_not_be_order_than_current_date
  validate :end_date_should_be_newer_than_start_date

  def unavailable?
    return false if start_date.blank? || end_date.blank?
    
    Date.current.to_date < start_date || Date.current.to_date >= end_date
  end

  private

  def menu_should_be_unique_for_restaurant 
    name = self.name
    menus = self.restaurant.menus
    return unless name.present?

    if menus.where(name: name).where.not(id: self.id).exists?
      errors.add :name, 'já existe'
    end
  end

  def dates_presence
    if start_date.present? && end_date.blank?
      errors.add(:end_date, 'data de fim não pode estar presente')
    elsif end_date.present? && start_date.blank?
      errors.add(:start_date, 'data de início deve estar presente')
    end
  end

  def start_date_should_not_be_order_than_current_date
    if start_date.present? && end_date.present? && start_date < Date.current
      errors.add(:start_date, 'não pode ser mais antiga que a data atual')
    end
  end

  def end_date_should_be_newer_than_start_date
    if start_date.present? && end_date.present? && end_date <= start_date 
      errors.add(:end_date, 'data de encerramento deve ser mais nova que a data de início')
    end
  end

  scope :valid_menus, -> {where('? BETWEEN start_date AND end_date OR start_date IS NULL', Date.current.to_date)}
end
