class BookingsController < ApplicationController
  before_action :set_product_and_variant, only: [:new, :create]
  before_action :set_booking, only: [:confirm, :cancel, :pick_up, :back_in_stock]

  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @bookings = Booking.where.not(actual_state: ['pending', 'confirmed'])
                       .order(created_at: :desc)
  end

  def current_bookings
    @bookings = Booking.where(actual_state: ['pending', 'confirmed', 'closed'])
                       .order(created_at: :desc)
    @bookings.each(&:booking_closed?)
  end

  def new
    @booker = Booker.new
    @booking = Booking.new
  end

  def create
    @booker = Booker.new(booking_params[:booker])

    return render :new unless @booker.save

    @booking = Booking.new(
      booker: @booker,
      product: @product,
      variant: @variant
    )
    @booking.save ? (redirect_to products_path) : (render :new)
  end

  def confirm
    @booking.confirm_booking
    redirect
  end

  def cancel
    @booking.cancel_booking
    redirect
  end

  def pick_up
    @booking.pick_up
    redirect
  end

  def back_in_stock
    @booking.back_in_stock
    redirect
  end

  private

  def booking_params
    params.require(:booking).permit(booker: [:email, :email_confirmation, :phone_number, :first_name, :last_name])
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_product_and_variant
    @product = Product.find_by(reference: params[:product_reference])
    @variant = @product.variants.find_by(size: params[:size])
  end

  def redirect
    @booking.save ? (redirect_to current_bookings_path) : (render :index)
  end
end
