class Booking < ApplicationRecord
  belongs_to :lesson
  has_one :no_show_charge
  has_one :billing_adjustment

  class BookingNoShowError < StandardError; end

  NO_SHOW_DURATION = 4.days

  def no_show!
    raise BookingNoShowError.new("Cannot mark no show for `cancelled` bookings.") if status == "cancelled"
    raise BookingNoShowError.new("Booking already marked as `no_show`.") if status == "no_show"

    self.transaction do
      create_no_show_charge! if in_no_show_window?
      create_billing_adjustment! if different_billing_window?
      update!(status: "no_show")
    end
  end

  def in_no_show_window?
    Time.now <= no_show_end
  end

  def no_show_end
    lesson.end_time + NoShowCharge::NO_SHOW_DURATION
  end

  def different_billing_window?
    lesson.end_time < most_recent_billing_end
  end

  def most_recent_billing_end
    billing_end = Time.now.beginning_of_month + 4.days
    billing_end -= 1.month if Time.now < billing_end
    billing_end
  end
end
