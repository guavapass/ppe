class NoShowCharge < ApplicationRecord

  DEFAULT_PRICE = 15

  belongs_to :booking

  before_create { self.price = DEFAULT_PRICE }
end
