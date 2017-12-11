class Booking < ApplicationRecord
	belongs_to :lesson
	has_many :no_show_charges
	has_one :billing_adjustment

	def no_show!
		no_show_validation

		update(status: 'no_show')

		return true if ended_no_show_charge_fee_window

		no_show_charge = no_show_charges.create

		return true unless no_show_charge
		manage_billing_adjustment(no_show_charge)
	end

	private

	def ended_no_show_charge_fee_window
		Time.current > (lesson.ends_at + 4.days)
	end

	def no_show_validation
		raise StandardError.new('Cannot mark no show for `cancelled` bookings.') if status == 'cancelled'
		raise StandardError.new('Booking already marked as `no_show`.') if status == 'no_show'
	end

	def manage_billing_adjustment(no_show_charge)
		this_month_4th = Date.new(Time.current.year, Time.current.month, 4)

		return true if lesson.ends_at > this_month_4th && lesson.ends_at < Date.new(this_month_4th.next_month.year, this_month_4th.next_month.month, 4)

		create_billing_adjustment(price: no_show_charge.price)
	end
end
