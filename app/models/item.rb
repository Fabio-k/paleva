class Item < ApplicationRecord
  self.inheritance_column = :type
  has_one_attached :photo
  belongs_to :restaurant
  has_many :portions
  has_many :item_caracteristics
  has_many :caracteristics, through: :item_caracteristics
  validates :name, :description, presence: true
end
