class AlterQuantityToOrderPortions < ActiveRecord::Migration[7.2]
  def change
    change_column_default :order_portions, :quantity, from: nil, to: 1
  end
end
