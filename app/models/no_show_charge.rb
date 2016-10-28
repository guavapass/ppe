class NoShowCharge < ApplicationRecord
  belongs_to :booking

  DEFAULT_PRICE = 15
  UPDATE_WINDOW = 4.0

  before_create { self.price = DEFAULT_PRICE }
  validate :validate_window

  def validate_window
    errors.add(:booking_id,'Out of update window') if
      (Time.now - self.booking.lesson.finish_date) / (24 * 3600) > UPDATE_WINDOW
  end
end
