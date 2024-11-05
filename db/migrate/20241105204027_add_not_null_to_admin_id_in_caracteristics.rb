class AddNotNullToAdminIdInCaracteristics < ActiveRecord::Migration[7.2]
  def change
    change_column_null :caracteristics, :admin_id, false
  end
end
