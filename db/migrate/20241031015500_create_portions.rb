class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.string :description
      t.references :item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
