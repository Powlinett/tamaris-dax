class BookingsController < ApplicationController
  before_action :set_product_and_variant, only: [:new, :create]
  before_action :set_booking, only: [:confirm, :cancel, :pick_up]

  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @bookings = Booking.all.order(created_at: :desc)
  end

  def new
    @booker = Booker.new
    @booking = Booking.new
  end

  def create
    @booker = Booker.new(booking_params[:booker])

    if @booker.save
      @booking = Booking.new(
        booker: @booker,
        product: @product,
        variant: @variant
      )
      if @booking.save
        redirect_to products_path
      else
        render :new
      end
    else
      render :new
    end
  end

  def confirm
    @booking.confirm_booking

    redirect_to bookings_path
  end

  def cancel
    @booking.cancel_booking

    redirect_to bookings_path
  end

  def pick_up
    @booking.pick_up

    redirect_to bookings_path
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
end
