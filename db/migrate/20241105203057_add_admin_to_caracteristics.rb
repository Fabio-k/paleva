class AddAdminToCaracteristics < ActiveRecord::Migration[7.2]
  def change
    add_reference :caracteristics, :admin, foreign_key:  true
  end
end
