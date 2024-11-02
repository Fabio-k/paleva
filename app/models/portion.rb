class Portion < ApplicationRecord
  has_many :portion_prices
  belongs_to :item
  validates :description, presence: true
end
