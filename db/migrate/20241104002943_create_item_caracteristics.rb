class CreateItemCaracteristics < ActiveRecord::Migration[7.2]
  def change
    create_table :item_caracteristics do |t|
      t.references :caracteristic, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
