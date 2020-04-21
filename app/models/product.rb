class Product < ApplicationRecord
  has_many :photo_attachments
  has_many :photos, through: :photo_attachments
  has_many :bookings

  validates :reference, presence: true
end
