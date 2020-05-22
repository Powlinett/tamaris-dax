class ProductFeature < ApplicationRecord
  has_many :products

  serialize :features_hash, Hash

  validates :features_hash, presence: true
  validates :description, presence: true
end
