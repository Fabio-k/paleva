class AddIsAciveToBeverages < ActiveRecord::Migration[7.2]
  def change
    add_column :beverages, :is_active, :boolean, default: true
  end
end
