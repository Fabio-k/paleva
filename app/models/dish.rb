class Dish < ApplicationRecord
  belongs_to :restaurant
  validates :name, :description, presence: true
  has_one_attached :photo
end
