class Product < ApplicationRecord
  has_many :photos
  has_many :bookings
end
