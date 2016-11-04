class Lesson < ApplicationRecord
  def duration
    duration_in_minutes.minutes
  end

  def finished_at
    starts_at + duration
  end
end
