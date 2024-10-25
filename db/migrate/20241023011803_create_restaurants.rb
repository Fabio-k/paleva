class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :code
      t.string :brand_name
      t.string :corporate_name
      t.string :registration_number
      t.string :street
      t.string :address_number
      t.string :city
      t.string :state
      t.string :cep
      t.string :phone_number
      t.string :email
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
