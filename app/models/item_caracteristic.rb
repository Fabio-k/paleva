class ItemCaracteristic < ApplicationRecord
  belongs_to :caracteristic
  belongs_to :item
end
