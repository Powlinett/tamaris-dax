require 'rails_helper'

feature 'Display products' do
  before(:all) do
    @product = create(:product)
  end

  scenario "with 'chaussures' as category" do
    visit category_path('chaussures')

    expect(page).to have_content "products-index"
  end
end
