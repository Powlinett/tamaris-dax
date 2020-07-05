class BookingMailer < ApplicationMailer
  add_template_helper(ProductsHelper)

  before_action :set_booking
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.registration.subject
  #
  def registration
    mail(to: @booker.email, subject: 'Votre réservation sur Tamaris-Dax') do |format|
      format.html { render :registration }
      format.text { render :registration }
    end
  end

  def confirmation
    mail(to: @booker.email, subject: 'Confirmation de votre réservation') do |format|
      format.html { render :confirmation }
      format.text { render :confirmation }
    end
  end

  def cancel
    mail(to: @booker.email, subject: "Votre réservation n'a pas pu être confirmée") do |format|
      format.html { render :cancel }
      format.text { render :cancel }
    end
  end

  private

  def set_booking
    @booking = params[:booking]
    @booker = @booking.booker
    @product = @booking.product
    @variant = @booking.variant
  end
end
