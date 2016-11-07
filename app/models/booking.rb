class Booking < ApplicationRecord
  belongs_to :lesson

  NO_SHOW_WINDOW = 4.days

  def no_show!
    check_no_show_condition!
    ActiveRecord::Base.transaction do
      self.update(status: "no_show")

      # we should be aware of transaction issue here
      if Time.now - lesson.starts_at <= NO_SHOW_WINDOW
        # we raise an error here if the record is not actually persisted
        NoShowCharge.create!()
      end

      if lesson.starts_at < previous_payout_date
        BillingAdjustment.create!(booking: self)
      end
    end
    
    true
  end

  private
  def check_no_show_condition!
    if self.status == "cancelled"
      raise StandardError, "Cannot mark no show for `cancelled` bookings."
    elsif self.status == "no_show"
      raise StandardError, "Booking already marked as `no_show`."
    end
  end

  def previous_payout_date
    today = Date.today
    Date.new(today.year, today.month, 5)
  end
end
