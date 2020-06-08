class HomePage < ApplicationRecord
  has_many :products
  has_many :special_offers, dependent: :destroy
end
