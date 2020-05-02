class ProductsController < ApplicationController
  require 'open-uri'
  include Scraper

  before_action :set_product, only: [:create]
  skip_before_action :authenticate_user!,
                     only: [:index, :show, :all_shoes, :all_accessories, :all_offers]

  def index
    @products = Product.all
  end

  def all_shoes
    @products = Product.where(category: 'chaussures')
  end

  def all_accessories
    @products = Product.where(category: 'accessoires')
  end

  def all_offers
    @products = Product.where(former_price: (1..300))
  end

  def new
    @product = Product.new
    @variant = Variant.new
  end

  def create
    if @product.nil?
      @product = Product.new(product_data(product_params[:reference]))
    end
    if @product.save
      @variant = update_variant(product_params[:variants], @product)
      save_and_redirect
    end
  end

  def show
    @product = Product.find_by(reference: params[:reference])
    @other_colors = Product.where("reference like ?", "%#{@product.common_ref}%")
  end

  private

  def to_param
    reference
  end

  def set_product
    @product = Product.find_by(reference: product_params[:reference])
  end

  def product_params
    params.require(:product).permit(:reference, variants: [:size, :stock])
  end

  def update_variant(params, product)
    @variant = product.variants.find_by(size: params[:size].to_i)
    @variant.update_stock(params[:stock].to_i)
    @variant
  end

  def save_and_redirect
    if @variant.save
      redirect_to product_path(@product.reference), notice: 'Produit ajouté :)'
    else
      flash.now[:alert] = 'Produit introuvable sur Tamaris.com :('
      render :new
    end
  end
end
