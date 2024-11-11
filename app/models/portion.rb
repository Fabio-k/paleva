class Portion < ApplicationRecord
  belongs_to :item
  has_many :portion_prices
  validates :description, presence: true

  def show_price
    price = self.price.to_s
    price.insert(-3, ',')
    price.insert(-4, '0' ) if self.price < 100
    "R$ #{price}"
  end
end
