class Booking < ApplicationRecord

  belongs_to :lesson
  has_one :no_show_charge
  has_one :billing_adjustment

  NO_SHOW_WINDOW = 4.days

  def no_show!
    raise 'Cannot mark no show for `cancelled` bookings.' if cancelled?
    raise 'Booking already marked as `no_show`.' if no_show?
    self.transaction do
      create_no_show_charge! if within_no_show_window?
      create_billing_adjustment! if start_within_last_month_payout? && Date.today > previous_payout_date
      update!(status: 'no_show')
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def cancelled?
    status == 'cancelled'
  end

  def no_show?
    status == 'no_show'
  end

  def within_no_show_window?
    Time.now <= lesson.starts_at + NO_SHOW_WINDOW + lesson.duration_in_minutes.minutes
  end

  def start_within_last_month_payout?
    lesson.starts_at < previous_payout_date
  end

  def previous_payout_date
    Date.today.beginning_of_month + 4.days
  end

end
