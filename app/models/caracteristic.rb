class Caracteristic < ApplicationRecord
  has_many :items, through: :item_caracteristic
  validates :name, presence: true
end
