class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items
  has_many :items, through: :menu_items
  validates :name, presence: true 
  validate :menu_should_be_unique_for_restaurant, on: [:create, :update]

  private

  def menu_should_be_unique_for_restaurant 
    name = self.name
    menus = self.restaurant.menus
    return unless name.present?

    if menus.where(name: name).where.not(id: self.id).exists?
      errors.add :name, 'já existe'
    end
  end

end
