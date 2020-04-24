class Product < ApplicationRecord
  has_many :bookings
  has_many :variants

  serialize :photos_urls, Array

  validates :reference, presence: true, uniqueness: true
  validates :category, presence: true
  validates :model, presence: true
  validates :price, presence: true, inclusion: { in: (0..400) }
end
