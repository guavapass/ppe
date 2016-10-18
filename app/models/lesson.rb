class Lesson < ApplicationRecord

  def duration
    duration_in_minutes.minutes
  end

end
