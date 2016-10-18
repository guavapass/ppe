class NoShowCharge < ApplicationRecord

  DEFAULT_PRICE = 15

  before_create { self.price = DEFAULT_PRICE }
end
