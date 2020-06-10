class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @home_page = HomePage.first
    @product = @home_page.product
    # @special_offer = @home_page.special_offer unless @home_page.special_offer.nil?
  end

  def contact
  end

  def store
  end

  def location
  end
end
