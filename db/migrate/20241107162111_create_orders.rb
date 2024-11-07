class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :code
      t.string :client_name
      t.string :phone_number
      t.string :email
      t.string :cpf
      t.integer :status, default: 0
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
