class Item < ApplicationRecord
  self.inheritance_column = :type
  has_one_attached :photo
  belongs_to :restaurant
  has_many :portions
  validates :name, :description, presence: true
end
