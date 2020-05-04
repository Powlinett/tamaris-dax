class BookingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.registration.subject
  #
  def registration
    @booking = params[:booking]
    @booker = @booking.booker
    @product = @booking.product
    @variant = @booking.variant

    mail(to: @booker.email, subject: 'Votre réservation sur Tamaris-Dax')
  end
end
