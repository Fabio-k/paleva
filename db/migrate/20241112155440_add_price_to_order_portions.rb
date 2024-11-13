class AddPriceToOrderPortions < ActiveRecord::Migration[7.2]
  def change
    add_column :order_portions, :price, :integer
  end
end
