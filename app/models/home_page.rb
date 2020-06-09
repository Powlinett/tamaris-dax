class HomePage < ApplicationRecord
  has_one :product
  has_one :special_offer, dependent: :destroy

  # accepts_nested_attributes_for :products
  validates :product, presence: true
end
