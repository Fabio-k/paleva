class RemoveAttributesFromDishes < ActiveRecord::Migration[7.2]
  def change
    remove_column :dishes, :name, :string
    remove_column :dishes, :description, :string
    remove_column :dishes, :calories, :string
    remove_column :dishes, :restaurant_id, :integer
    remove_column :dishes, :is_active, :boolean
  end
end
