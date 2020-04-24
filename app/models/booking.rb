class Booking < ApplicationRecord
  belongs_to :booker
  belongs_to :product
  belongs_to :variant

  validates :booker, presence: true
  validates :product, presence: true
  validates :variant, presence: true
end
