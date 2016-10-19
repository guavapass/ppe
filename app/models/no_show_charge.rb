class NoShowCharge < ApplicationRecord
  NO_SHOW_WINDOW_IN_DAY = 4

  belongs_to :booking

  DEFAULT_PRICE = 15

  before_create { self.price = DEFAULT_PRICE }

  validate :timeframe_check, on: :create

  def timeframe_check
    errors.add(:no_show_charge, 'time is outside of no show window') if
      Time.now - (booking.lesson.starts_at + booking.lesson.duration) >= NO_SHOW_WINDOW_IN_DAY.days
  end
end
