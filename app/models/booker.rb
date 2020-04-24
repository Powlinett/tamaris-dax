class Booker < ApplicationRecord
  has_many :bookings

  validates :email, presence: true, confirmation: { case_sensitive: false }
  validates :email_confirmation, presence: true
  validates :phone_number, presence: true
  validates :first_name, :last_name, presence: true
end
