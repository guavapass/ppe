class Booking < ApplicationRecord

  NO_SHOW_WINDOW_IN_DAY = 4

  belongs_to :lesson
  has_one :no_show_charge

  validate :status_check, on: :update

  after_update :create_no_show_charge

  def status_check
    errors.add(:base, "Booking already marked as `no_show`") if
      self.status_was == 'no_show'
  end

  def no_show!
    # return false if self.status.in? [:canceled, :no_show]
    self.update(status: :no_show)
  end

  def create_no_show_charge
    NoShowCharge.find_or_create_by(booking: self)
  end
end
