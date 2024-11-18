class AddReasonMessageToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :reason_message, :string
  end
end
