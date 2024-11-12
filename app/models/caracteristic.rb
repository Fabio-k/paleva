class Caracteristic < ApplicationRecord
  belongs_to :restaurant
  has_many :item_caracteristics
  has_many :items, through: :item_caracteristics
  validates :name, presence: true
end
