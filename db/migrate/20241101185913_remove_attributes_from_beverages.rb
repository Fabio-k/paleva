class RemoveAttributesFromBeverages < ActiveRecord::Migration[7.2]
  def change
    remove_column :beverages, :name, :string
    remove_column :beverages, :description, :string
    remove_column :beverages, :calories, :string
    remove_column :beverages, :restaurant_id, :integer
    remove_column :beverages, :is_active, :boolean
  end
end
