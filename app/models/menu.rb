class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items
  has_many :items, through: :menu_items
  validates :name, presence: true 
  validate :menu_should_be_unique_for_restaurant

  private

  def menu_should_be_unique_for_restaurant 
    name = self.name
    menus = self.restaurant.menus
    return unless name.present?

    if menus.find_by(name: name).present? 
      errors.add :name, 'já existe'
    end
  end

end
