class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :type 
      t.string :calories
      t.references :restaurant, null: false, foreign_key: true
      t.boolean :is_active, default: true
      t.boolean :is_alcoholic

      t.timestamps
    end
  end
end
