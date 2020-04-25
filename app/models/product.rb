class Product < ApplicationRecord
  has_many :bookings, dependent: :nullify
  has_many :variants, dependent: :destroy

  serialize :photos_urls, Array

  validates :reference, presence: true, uniqueness: true
  validates :category, presence: true
  validates :model, presence: true
  validates :price, presence: true, inclusion: { in: (0..400) }
end
