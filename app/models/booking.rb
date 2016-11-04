class Booking < ApplicationRecord
  has_one :no_show_charge
  belongs_to :lesson
  has_one :billing_adjustment

  def no_show!
    raise "Cannot mark no show for `cancelled` bookings." if self.status == "cancelled"
    raise "Booking already marked as `no_show`." if self.status == "no_show"


    billing_adjustment_create

    self.transaction do
      self.create_no_show_charge if Time.now < no_show_window
      self.update!(status: "no_show")
    end
  end

  private

  def no_show_window
    lesson.starts_at + lesson.duration + 4.days
  end

  def billing_adjustment_create
    if (payment_range.cover?(Time.now) && !payment_range.cover?(lesson.finished_at))
      create_billing_adjustment
    end
  end

  def payment_range
    start_of_payment = Time.now.beginning_of_month + 4.days
    end_of_payment = start_of_payment + 1.month
    payment_range = start_of_payment..end_of_payment
  end
end
