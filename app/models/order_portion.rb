class OrderPortion < ApplicationRecord
  belongs_to :order
  belongs_to :portion
  validates :quantity, comparison: {greater_than: 0}
  before_validation :save_price, on: :create

  private

  def save_price
    self.price = self.portion.current_price
  end
end
