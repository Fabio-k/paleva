class AddIsAciveToDishes < ActiveRecord::Migration[7.2]
  def change
    add_column :dishes, :is_active, :boolean, default: true
  end
end
