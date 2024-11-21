class AddStartDateAndEndDateToMenu < ActiveRecord::Migration[7.2]
  def change
    add_column :menus, :start_date, :date
    add_column :menus, :end_date, :date
  end
end
