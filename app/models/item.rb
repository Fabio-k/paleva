class Item < ApplicationRecord
  self.inheritance_column = :type
  has_one_attached :photo
  belongs_to :restaurant
  has_many :portions
  has_many :item_caracteristics
  has_many :caracteristics, through: :item_caracteristics
  has_many :menu_items
  has_many :menus, through: :menu_items
  validates :name, :description, presence: true

  scope :valid, -> {where(is_active: true, is_removed: false)} 
end
