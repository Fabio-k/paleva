class CreateEmployeePreRegistrations < ActiveRecord::Migration[7.2]
  def change
    create_table :employee_pre_registrations do |t|
      t.string :cpf
      t.string :email
      t.boolean :is_used, default: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
