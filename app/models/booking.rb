class Booking < ApplicationRecord
  belongs_to :lesson
  has_one :no_show_charge
  has_one :billing_adjustment

  STANDARD_NO_SHOW_WINDOW = 4.days
  ADJUSTMENT_AFTER_DAY_OF_MONTH = 5

  def no_show!
    raise "Cannot mark no show for `cancelled` bookings." if cancelled?
    raise "Booking already marked as `no_show`." if no_show?

    create_no_show_charge.save if within_standard_no_show_window?
    create_billing_adjustment(price: NoShowCharge::DEFAULT_PRICE)  if needs_billing_adjustment?

    update(status: "no_show")
  end

  private

  def cancelled?
    status == "cancelled"
  end

  def no_show?
    status == "no_show"
  end

  def within_standard_no_show_window?
    Time.now <= lesson.starts_at +
                lesson.duration + STANDARD_NO_SHOW_WINDOW
  end

  def needs_billing_adjustment?
    lesson.starts_at < cut_off_date && Time.now > cut_off_date
  end

  def cut_off_date
    next_month = lesson.starts_at + 1.month
    Time.local(next_month.year, next_month.month, ADJUSTMENT_AFTER_DAY_OF_MONTH, 0, 0, 0)
  end
end
