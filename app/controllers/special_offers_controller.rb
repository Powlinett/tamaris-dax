class SpecialOffersController < ApplicationController
  def destroy
    @special_offer = SpecialOffer.find(params[:id])
    @special_offer.destroy

    redirect_to edit_home_page_path
  end
end
