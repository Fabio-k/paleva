class OrderPortion < ApplicationRecord
  belongs_to :order
  belongs_to :portion
end
