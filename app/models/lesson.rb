class Lesson < ApplicationRecord
  has_many :bookings

  def duration
    duration_in_minutes.minutes
  end

  def finish_date
    self.starts_at + duration
  end
end
