class BookingsController < ApplicationController
  before_action :set_product_and_variant, only: [:new, :create]
  def index
    @bookings = Booking.all
  end

  def new
    @booker = Booker.new
  end

  def create
    @booker = Booker.new(booker_params)

    if @booker.save
      @booking = Booking.create(booker: @booker, product: @product, variant: @variant)
      redirect_to product_bookings_path
    else
      redirect_to product_path(@product.reference)
    end
  end

  private

  def booker_params
    params.require(:booker).permit(:email, :email_confirmation, :phone_number, :first_name, :last_name)
  end

  def set_product_and_variant
    @variant = Variant.find(params[:variant_id])
    @product = @variant.product
  end
end
