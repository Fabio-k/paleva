class MoveCaracteristicsReferenceToRestaurants < ActiveRecord::Migration[7.2]
  def change
    remove_reference :caracteristics, :admin, index: true, foreign_key: true
    add_reference :caracteristics, :restaurant, foreign_key: true
  end
end
