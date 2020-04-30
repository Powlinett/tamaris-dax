class BookingsController < ApplicationController
  before_action :set_product_and_variant, only: [:new, :create]
  before_action :set_booking, only: [:confirm, :cancel, :pick_up]

  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @bookings = Booking.all
  end

  def new
    @booker = Booker.new
  end

  def create
    @booker = Booker.new(booker_params)

    if @booker.save
      @booking = Booking.create(
        booker: @booker,
        product: @product,
        variant: @variant
      )
      redirect_to products_path
    else
      redirect_to product_path(@product.reference)
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

  def booker_params
    params.require(:booker).permit(:email, :email_confirmation, :phone_number, :first_name, :last_name)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_product_and_variant
    @product = Product.find_by(reference: params[:product_reference])
    @variant = @product.variants.find_by(size: params[:size])
  end
end
