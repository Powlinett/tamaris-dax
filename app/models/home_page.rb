class HomePage < ApplicationRecord
  belongs_to :product, required: true
  has_one :special_offer, dependent: :destroy

  validates :product, presence: true
end
