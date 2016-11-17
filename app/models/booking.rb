class Booking < ApplicationRecord

  belongs_to :lesson
  has_one :no_show_charge
  has_one :billing_adjustment

  def no_show!
    validate_no_show
    Booking.transaction do

      self.status = 'no_show'
      if self.lesson.starts_at > (Time.now - (4.days + self.lesson.duration))
        self.create_no_show_charge
        self.create_billing_adjustment(price: self.no_show_charge.price) if (self.lesson.starts_at < current_billing_date) && Time.now > current_billing_date
      end
      self.save
    end
    return true
  end

  private

  def validate_no_show
    raise Exception.new('Booking already marked as `no_show`.') if self.status == 'no_show'
    raise Exception.new("Cannot mark no show for `#{self.status}` bookings.") if !['completed', 'pending'].include? self.status
  end

  def current_billing_date
    Date.today.beginning_of_month + 4.days
  end

end
