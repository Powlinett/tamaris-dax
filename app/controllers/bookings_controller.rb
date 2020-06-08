class BookingsController < ApplicationController
  before_action :set_product_and_variant, only: [:new, :create]
  before_action :set_booking,
                only: [:confirm, :cancel, :pick_up, :back_in_stock, :undo_last_action]

  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @bookings = Booking.where(actual_state: ['back', 'picked', 'canceled'])
                       .order(updated_at: :desc)
    paginate_bookings
  end

  def current_bookings
    @bookings = Booking.where(actual_state: ['pending', 'confirmed', 'closed'])
                       .order(created_at: :desc)
    paginate_bookings
    render :index
  end

  def new
    @booker = Booker.new
    @booking = Booking.new
  end

  def create
    @booker = Booker.new(booking_params[:booker])

    @booking = Booking.new(
      booker: @booker,
      product: @product,
      variant: @variant
    )
    if @booker.save && @booking.save
      redirect_to root_path, notice: 'Votre réservation a bien été effectuée, nous vous avons envoyé un e-mail de confirmation'
    else
      render :new
    end
  end

  def confirm
    @booking.confirm
    redirect
  end

  def cancel
    @booking.cancel
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

  def search
    redirect_to(bookings_path) && return if params[:query].empty?

    @bookings = Booking.search_in_bookings(params[:query])
    @bookings = @bookings.page(params[:page])
    render :index
  end

  private

  def booking_params
    params.require(:booking)
          .permit(booker: [:email, :email_confirmation, :phone_number, :first_name, :last_name])
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_product_and_variant
    @product = Product.find_by(reference: params[:product_reference])
    @variant = @product.variants.find_by(size: params[:size])
  end

  def redirect
    redirect_to current_bookings_path, notice: 'Réservation mise à jour'
  end

  def paginate_bookings
    @bookings = Kaminari.paginate_array(@bookings).page(params[:page]).per(10)
  end
end
