class RemoveStatusFromOrder < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :status, :integer
  end
end
