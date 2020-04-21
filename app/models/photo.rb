class Photo < ApplicationRecord
  has_many :photo_attachments
  has_many :products, through: :photo_attachments
end
