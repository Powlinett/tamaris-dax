class Booker < ApplicationRecord
  has_many :bookings

  validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i },
                    confirmation: { case_sensitive: false }
  validates :email_confirmation, presence: true
  validates :phone_number, presence: true, format: { with: /\A(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}\z/ }
  validates :first_name, :last_name, presence: true

  include PgSearch::Model
  pg_search_scope :search_in_bookers,
                  against: [:last_name, :first_name, :email, :phone_number],
                  using: {
                    tsearch: { prefix: true }
                  }
end
