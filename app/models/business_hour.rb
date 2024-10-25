class BusinessHour < ApplicationRecord
  belongs_to :restaurant
  enum :day_of_week, {:monday=>0, :tuesday=>1, :wednesday=>3, :thursday=>4, :friday=>5, :saturday=>6, :sunday=>7}
  validates :opening_hour, :closing_hour, presence: true
end
