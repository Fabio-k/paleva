class CreateOrderStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :order_statuses do |t|
      t.integer :status, default: 0
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
