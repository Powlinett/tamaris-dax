class HomePagesController < ApplicationController
  before_action :set_home_page, only: [:edit, :update]

  def edit
    @product = @home_page.product

    unless @home_page.special_offer.nil?
      @special_offer = @home_page.special_offer
    else
      @special_offer = SpecialOffer.new
    end
  end

  def update
    unless special_offer_params[:title].blank?
      special_offer = SpecialOffer.new(special_offer_params)
      special_offer.home_page = @home_page
      special_offer.save
    end

    product = Product.find_by(reference: product_reference_params)
    product.update(home_page: @home_page)

    if @home_page.update(product: product)
      redirect_to root_path
    else
      render :edit, alert: "Erreur lors de la modification de la page d'accueil.
                            Veuillez vérifier les champs du formulaire."
    end
  end

  private

  def home_page_params
    params.require(:home_page)
      .permit(product: [:reference],
              special_offer: [:title, :description, :starting_date, :ending_date])
  end

  def special_offer_params
    home_page_params[:special_offer]
  end

  def product_reference_params
    home_page_params[:product][:reference]
  end

  def set_home_page
    @home_page = HomePage.first
  end
end
