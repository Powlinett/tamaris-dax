require 'rails_helper'

describe 'Product' do
  before(:all) do
    @product1 = create(:product, reference: "1-1-22107-24-003")
    @product2 = create(:product, reference: "1-1-22107-24-004", former_price: 79.95)
    Product.all.each { |product| product.variants.update_all(stock: rand(0..10)) }

    @user = User.create(email: 'test@test.com', password: '123456')
  end

  feature 'Display products' do
    scenario "by category" do
      visit category_path(@product1.category)

      expect(page).to have_selector ".products-index"
      expect(page.find(:css, '.index-category .index-title h1').text).to eq(@product1.category)
    end

    scenario "with offers" do
      visit category_path('promotions')

      expect(page).to have_selector ".products-index"
      expect(page.find(:css, '.index-category .index-title h1').text).to eq('promotions')
    end

    scenario "by sub_category" do
      visit sub_category_path(@product1.category, @product1.sub_category)

      expect(page).to have_selector ".products-index_by_sub_category"
      expect(page.find(:css, '.index-category .index-title h1').text).to eq(@product1.sub_category)
    end

    # scenario "by searching", js: true do
    #   visit root_path

    #   fill_in('query', with: @product1.sub_category, match: :first)
    #   page.execute_script("$('form.products-search-form').submit()")

    #   expect(page.current_url).to include(@product1.sub_category)
    #   page.find(@product1.reference)
    # end
  end

  feature 'Show a product' do
    scenario 'from the index' do
      visit products_path

      click_link(@product1.reference)

      expect(page.current_url).to include(@product1.reference)
      expect(page.find('h1.product-model').text).to eq(@product1.model)
    end
  end

  feature 'Create a product' do
    before do
      visit new_user_session_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password

      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'when a user enter a new reference' do
      reference = '1-1-27153-34-941'

      visit new_product_path

      within '#new_product' do
        fill_in 'product_reference', with: reference
        fill_in 'product_variants_size', with: 37
        fill_in 'product_variants_stock', with: 7

        click_on 'Créer le produit'
      end

      expect(page.current_url).to include(reference)
      expect(page.find('.alert.alert-info.alert-dismissible').text).to include('Produit ajouté')
    end

    scenario 'when a user enter a reference that already exists' do
      reference = '1-1-27153-34-941'

      visit new_product_path

      within '#new_product' do
        fill_in 'product_reference', with: reference
        fill_in 'product_variants_size', with: 37
        fill_in 'product_variants_stock', with: 7

        click_on 'Créer le produit'
      end

      expect(page.current_url).to include(reference)
      expect(page.find('.alert.alert-info.alert-dismissible').text).to include('Produit ajouté')
      expect(Product.last.variants.find_by(size: 37).stock).to eq(14)
    end
  end
end

