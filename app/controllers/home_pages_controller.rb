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
    special_offer = update_or_create_special_offer(special_offer_params)

    @product = Product.find_by(reference: product_reference_params)

    if @home_page.update(product: @product) && special_offer
      redirect_to root_path, notice: "Page d'accueil mise à jour"
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

  def update_or_create_special_offer(params)
    return true if params[:title].empty?

    if @home_page.special_offer.nil?
      @special_offer = SpecialOffer.new(params)
      @special_offer.home_page = @home_page
      @special_offer.save
    else
      @special_offer = @home_page.special_offer
      @special_offer.update(params)
    end
  end
end
