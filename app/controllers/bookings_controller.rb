class BookingsController < ApplicationController
  before_action :set_product_and_variant, only: [:new, :create]
  def index
    @bookings = Booking.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @booking = Booking.create(user: @user, product: @product, variant: @variant)
      redirect_to product_bookings_path
    else
      redirect_to product_path(@product.reference)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :phone_number, :first_name, :last_name)
  end

  def set_product_and_variant
    @variant = Variant.find(params[:variant_id])
    @product = @variant.product
  end
end
