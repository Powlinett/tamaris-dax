class PhotoAttachment < ApplicationRecord
  belongs_to :photo
  belongs_to :product
end
