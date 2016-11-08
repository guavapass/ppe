class Booking < ApplicationRecord

  CANCELLED_STATUS = "cancelled"
  NO_SHOW_STATUS = "no_show"
  ALLOWED_TIME_TO_MARK_AS_NO_SHOW = 4.days
  BILLING_CUT_OVER_DAY = 5

  belongs_to :lesson
  has_one :no_show_charge, dependent: :destroy

  def no_show!
    raise("Cannot mark no show for `cancelled` bookings.") \
      if self.status == CANCELLED_STATUS

    raise("Booking already marked as `no_show`.") \
      if self.status == NO_SHOW_STATUS

    transaction do
      self.update({ status: "no_show" })

      lesson_ends_at = self.lesson.starts_at + self.lesson.duration_in_minutes.minutes
      if Time.now - lesson_ends_at < ALLOWED_TIME_TO_MARK_AS_NO_SHOW
        NoShowCharge.create({ booking: self })
      end

      # create billing adjustment:
      # mark no show happens after 5th of the month AND
      # lesson starts on last month
      next_billing = Date.parse((self.lesson.starts_at + 1.month).strftime("#{BILLING_CUT_OVER_DAY}-%m-%Y"))
      BillingAdjustment.create({ booking: self }) if Time.now > next_billing
    end

    true
  end
end
