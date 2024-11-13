class OrderPortion < ApplicationRecord
  belongs_to :order
  belongs_to :portion
  before_validation :save_price, on: :create

  private

  def save_price
    self.price = self.portion.current_price
  end
end
