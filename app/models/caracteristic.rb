class Caracteristic < ApplicationRecord
  belongs_to :admin
  has_many :items, through: :item_caracteristic
  validates :name, presence: true
end
