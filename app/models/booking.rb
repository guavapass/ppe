class Booking < ApplicationRecord
  belongs_to :lesson
  has_many :no_show_charges

  def no_show!
    raise_already_no_show if self.status == 'no_show'
    raise_already_cancelled if self.status == 'cancelled'
    self.status = 'no_show'
    self.no_show_charges.create if self.save
  end

  def raise_already_cancelled
    raise "Cannot mark no show for `cancelled` bookings."
  end

  def raise_already_no_show
    raise "Booking already marked as `no_show`."
  end

end
