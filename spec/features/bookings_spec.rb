require 'rails_helper'

describe 'Booking' do
  before(:all) do
    @product = create(:product, reference: "1-1-22107-24-005")
    @product.variants.find_by(size: 37).update(stock: 7)

    @booker = create(:booker)

    @booking = create(:booking, booker: @booker)

    @user = create(:user)

    HomePage.create(product: Product.last)
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

      expect{ click_on('Réserver maintenant') }.to change { Booking.count }.by(1)

      expect(page).to have_content 'Votre réservation a bien été effectuée'
    end

    scenario "from the product show" do
      visit product_path(@product.reference)

      click_on('37')

      expect(page.current_url).to include("#{@product.reference}/37")

      click_on 'Réserver en boutique'

      expect(page.current_url).to include("#{@product.reference}/37/bookings/new")

      fill_in 'booking_booker_last_name', with: @booker.last_name
      fill_in 'booking_booker_first_name', with: @booker.first_name
      fill_in 'booking_booker_email', with: @booker.email
      fill_in 'booking_booker_email_confirmation', with: @booker.email
      fill_in 'booking_booker_phone_number', with: @booker.phone_number

      expect{ click_on('Réserver maintenant') }.to change { Booking.count }.by(1)

      expect(page).to have_content 'Votre réservation a bien été effectuée'
    end
  end

  feature 'Display bookings' do
    before do
      Capybara.current_driver = :selenium_chrome_headless

      visit new_user_session_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_on 'Log in'
    end

    scenario "when they're opened" do
      visit current_bookings_path

      expect(page).to have_css "a[href='/products/#{@booking.product.reference}']"

      visit bookings_path

      expect(page).not_to have_css "a[href='/products/#{@booking.product.reference}']"
    end

    scenario "when they're former bookings" do
      @booking.update(actual_state: 'picked')

      visit bookings_path

      expect(page).to have_css "a[href='/products/#{@booking.product.reference}']"

      visit current_bookings_path

      expect(page).not_to have_css "a[href='/products/#{@booking.product.reference}']"
    end

    scenario "when a user search a booking", js: true do
      visit bookings_path

      within '#bookings-search' do
        fill_in 'query', with: @booking.booker.last_name
        page.execute_script("$('form.bookings-search').submit()")
      end

      expect(page.current_url)
        .to include("/bookings/recherche?utf8=%E2%9C%93&query=#{@booking.booker.last_name}")
      expect(page).to have_content(/#{@booking.booker.last_name}/i)
    end
  end

  feature 'Choose an action for a booking' do
    before do
      visit new_user_session_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'

      @booking.variant.update(stock: 10)
    end

    scenario "when it's pending and the user wants to confirm it" do
      visit current_bookings_path

      click_on 'En stock'

      @booking.reload

      expect(@booking.actual_state).to eq('confirmed')
      expect(page).to have_content 'Réservation mise à jour'
    end

    scenario "when it's pending and the user wants to cancel it" do
      visit current_bookings_path

      click_on 'Indisponible'

      @booking.reload

      expect(@booking.actual_state).to eq('canceled')
      expect(page).to have_content 'Réservation mise à jour'
    end

    scenario "when it's confirmed and the booker bought it" do
      @booking.confirm

      visit current_bookings_path

      click_on 'Encaissement'

      @booking.reload

      expect(@booking.actual_state).to eq('picked')
      expect(page).to have_content 'Réservation mise à jour'
    end

    scenario "when it's confirmed and the booker didn't buy it" do
      @booking.confirm

      visit current_bookings_path

      click_on 'Retour en vente'

      @booking.reload

      expect(@booking.actual_state).to eq('back')
      expect(page).to have_content 'Réservation mise à jour'
    end

    scenario "when ending_date is passed" do
      @booking.update(ending_date: Date.today - 1)
      @booking.is_closed?

      visit current_bookings_path

      click_on 'Retour en vente'

      @booking.reload

      expect(@booking.actual_state).to eq('back')
      expect(page).to have_content 'Réservation mise à jour'
    end
  end
end
