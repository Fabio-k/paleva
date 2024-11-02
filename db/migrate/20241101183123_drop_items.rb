class DropItems < ActiveRecord::Migration[7.2]
  def change
    drop_table :items do |t|
      t.string "name"
      t.string "description"
      t.integer "calories"
      t.integer "restaurant_id", null: false
      t.boolean "is_active"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["restaurant_id"], name: "index_items_on_restaurant_id"
    end
  end
end
