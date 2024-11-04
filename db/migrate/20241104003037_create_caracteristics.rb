class CreateCaracteristics < ActiveRecord::Migration[7.2]
  def change
    create_table :caracteristics do |t|
      t.string :name

      t.timestamps
    end
  end
end
