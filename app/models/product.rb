class Product < ApplicationRecord
  has_many :bookings

  serialize :photos_urls, Array

  validates :reference, presence: true
  validates :stock, presence: true
end
