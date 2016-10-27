class Booking < ApplicationRecord
  has_one :no_show_charge
  has_one :billing_adjustment
  belongs_to :lesson

  NO_SHOW_WINDOW = 4.days

  def no_show!
    case status
    when "cancelled"
      raise "Cannot mark no show for `cancelled` bookings."
    when "no_show"
      raise "Booking already marked as `no_show`."
    else
      create_billing_adjustment if Date.today > cutoff_date && lesson.starts_at < cutoff_date
      create_no_show_charge if Time.now < (lesson.starts_at + lesson.duration + NO_SHOW_WINDOW)
      update(status: "no_show")
    end
  end

  def cutoff_date
    Date.today.beginning_of_month + 4.days
  end
end
