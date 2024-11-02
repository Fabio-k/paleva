class PortionPrice < ApplicationRecord
  belongs_to :portion
  validates :price, presence: true

  def show_price
    price = self.price.to_s
    price.insert(-3, ',')
    price.insert(-4, '0' ) if self.price < 100
    "R$ #{price}"
  end
end
