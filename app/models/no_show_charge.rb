class NoShowCharge < ApplicationRecord
	belongs_to :booking

	NO_SHOW_DURATION = 4.days

  DEFAULT_PRICE = 15

  before_create { self.price = DEFAULT_PRICE }
end
