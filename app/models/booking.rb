class Booking < ApplicationRecord
  belongs_to :booker
  belongs_to :product
  belongs_to :variant

  after_initialize :set_defaults, unless: :persisted?

  validates :booker, presence: true
  validates :product, presence: true
  validates :variant, presence: true
  validates :starting_date, presence: true
  validates :ending_date, presence: true
  validates :actual_state, presence: true

  after_create :send_record_email

  include PgSearch::Model
  pg_search_scope :search_in_bookings,
                  associated_against: {
                    product: [:reference, :model, :category, :sub_category],
                    booker: [:first_name, :last_name, :email, :phone_number]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  def confirm
    self.former_state = actual_state
    self.actual_state = 'confirmed'
  end

  def cancel
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

  def is_closed?
    return false if ending_date > Date.today

    self.former_state = actual_state
    self.actual_state = 'closed'
    return true
  end

  # def undo_state_change
  #   self.actual_state = former_state
  # end

  private

  def set_defaults
    self.actual_state = 'pending'
    self.starting_date = Date.today if self.starting_date.nil?
    self.ending_date = starting_date + 3
  end

  def send_record_email
    BookingMailer.with(booking: self).registration.deliver_later
  end
end
