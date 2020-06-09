class HomePage < ApplicationRecord
  has_one :product
  has_one :special_offer, dependent: :destroy

  validates :product, presence: true
end
