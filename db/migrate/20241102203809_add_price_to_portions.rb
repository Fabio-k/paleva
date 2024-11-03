class AddPriceToPortions < ActiveRecord::Migration[7.2]
  def change
    add_column :portions, :price, :integer
  end
end
