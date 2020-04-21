class BookingsController < ApplicationController

  def new
    @booking = Booking.new
  end

  def create
    @user = User.create(user_params)
    @product = Product.first
    @booking = Booking.create()
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone_number, :first_name, :last_name)
  end
end
