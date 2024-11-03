class AddIsRemovedToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :is_removed, :boolean, default: false
  end
end
