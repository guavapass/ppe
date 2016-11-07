class Lesson < ApplicationRecord
  has_many :bookings
  def duration
    duration_in_minutes.minutes
  end

end
