require 'rails_helper'

describe HomePage do
  before do
    Capybara.current_driver = :selenium_chrome_headless

    @home_page = HomePage.first

    @user = User.last

    visit new_user_session_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "123456"
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
  end

  feature 'Edit the HomePage' do
    scenario 'when modifying product reference' do
      visit edit_home_page_path

      select("1-1-22107-24-005", from: 'home_page_product_reference')
      click_on "Mettre à jour la page d'accueil"

      @home_page.reload

      expect(page).to have_content "Page d'accueil mise à jour"
      expect(@home_page.product.reference).to eq("1-1-22107-24-005")
    end

    scenario 'when adding a special offer with title', js: true do
      visit edit_home_page_path

      page.execute_script("$('details.special-offer-part summary').click()")

      fill_in 'home_page_special_offer_title', with: 'Lorem ipsum duis ut minim.'
      click_on "Mettre à jour la page d'accueil"

      @home_page.reload

      expect(page).to have_content "Page d'accueil mise à jour"
      expect(@home_page.special_offer.title).to eq('Lorem ipsum duis ut minim.')
    end

    scenario 'when adding a special offer without title', js: true do
      visit edit_home_page_path

      page.execute_script("$('details.special-offer-part summary').click()")

      fill_in 'home_page_special_offer_description', with: 'Lorem ipsum duis ut minim.'
      click_on "Mettre à jour la page d'accueil"

      @home_page.reload

      expect(page).to_not have_content "Page d'accueil mise à jour"
      expect(@home_page.special_offer.nil?).to be true
    end


  end
end
