class Portion < ApplicationRecord
  belongs_to :item
  has_many :portion_prices
  validates :description, presence: true

  def show_price
    price = current_price.to_s
    price.insert(-3, ',')
    price.insert(-4, '0' ) if current_price < 100
    "R$ #{price}"
  end

  def current_price
    self.portion_prices.last.price
  end
end
