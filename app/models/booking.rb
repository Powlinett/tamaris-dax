class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :variant

  validates :user, presence: true
  validates :product, presence: true
  validates :variant, presence: true
end
