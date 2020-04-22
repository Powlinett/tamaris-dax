class BookingsController < ApplicationController

  def index
    @bookings = Booking.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @product = Product.all.sample

    if @user.save
      @booking = Booking.create(user: @user, product: @product)
      redirect_to bookings_path
    else
      redirect_to product_path(@product)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :phone_number, :first_name, :last_name)
  end
end
