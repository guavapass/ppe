class NoShowCharge < ApplicationRecord

  belongs_to :booking

  DEFAULT_PRICE = 15

  before_create { self.price = DEFAULT_PRICE }
end
