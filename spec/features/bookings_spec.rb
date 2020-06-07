require 'rails_helper'

describe 'Booking' do
  before(:all) do
    @product = create(:product, reference: "1-1-22107-24-003")
    @product.variants.find_by(size: 37).update(stock: 7)

    @booker = create(:booker)

    # @user = User.create(email: 'test@test.com', password: '123456')
  end

  feature 'Create a booking' do
    scenario 'from the index' do
      visit category_path('chaussures')

      within "##{@product.reference}" do
        click_on('37')
      end

      expect(page.current_url).to include("#{@product.reference}/37/bookings/new")

      fill_in 'booking_booker_last_name', with: @booker.last_name
      fill_in 'booking_booker_first_name', with: @booker.first_name
      fill_in 'booking_booker_email', with: @booker.email
      fill_in 'booking_booker_email_confirmation', with: @booker.email
      fill_in 'booking_booker_phone_number', with: @booker.phone_number

      click_on('Réserver maintenant')

      expect(page).to have_content 'Votre réservation a bien été effectuée'
      expect(Booking.count).to eq(1)

    end

    scenario "from the product's variant show" do
      visit product_path(@product.reference)

    end
  end
end
