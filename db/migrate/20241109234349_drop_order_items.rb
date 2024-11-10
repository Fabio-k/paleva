class DropOrderItems < ActiveRecord::Migration[7.2]
  def change
    drop_table :order_items
  end
end
