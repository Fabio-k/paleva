class CreatePortionPrices < ActiveRecord::Migration[7.2]
  def change
    create_table :portion_prices do |t|
      t.integer :price
      t.references :portion, null: false, foreign_key: true
      t.timestamps
    end
  end
end
