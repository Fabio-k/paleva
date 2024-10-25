class CreateBusinessHours < ActiveRecord::Migration[7.2]
  def change
    create_table :business_hours do |t|
      t.integer :day_of_week
      t.time :opening_hour
      t.time :closing_hour
      t.references :restaurant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
