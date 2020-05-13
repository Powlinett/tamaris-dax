class Booking < ApplicationRecord
  belongs_to :booker
  belongs_to :product
  belongs_to :variant

  validates :booker, presence: true
  validates :product, presence: true
  validates :variant, presence: true

  after_initialize :set_defaults, unless: :persisted?

  after_create :send_record_email

  include PgSearch::Model
  pg_search_scope :search_in_bookings,
                  associated_against: {
                    product: [:reference, :model, :category, :sub_category],
                    booker: [:first_name, :last_name, :email, :phone_number]
                  },
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }

  def set_defaults
    self.actual_state = 'pending'
    self.former_state = nil
    self.starting_date = Date.today.strftime("%A %d/%m/%Y")
    self.ending_date = (starting_date + 3).strftime("%A %d/%m/%Y")
  end

  def confirm_booking
    self.former_state = actual_state
    self.actual_state = 'confirmed'
  end

  def cancel_booking
    self.former_state = actual_state
    self.actual_state = 'canceled'
  end

  def pick_up
    self.former_state = actual_state
    self.actual_state = 'picked'
  end

  def back_in_stock
    self.former_state = actual_state
    self.actual_state = 'back'
  end

  def booking_closed?
    return unless ending_date < Date.today

    self.former_state = actual_state
    self.actual_state = 'closed'
  end

  def undo_state_change
    self.actual_state = former_state
  end

  private

  def send_record_email
    BookingMailer.with(booking: self).registration.deliver_later
  end
end
