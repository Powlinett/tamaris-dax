class ProductsController < ApplicationController
  require 'open-uri'
  include Scraper

  before_action :set_product, only: [:create]

  skip_before_action :authenticate_user!,
                     only: [:index, :show, :all_shoes, :all_accessories, :all_offers]

  def index
    @products = Product.all
    collect_only_in_stock
  end

  def all_shoes
    @products = Product.where(category: 'chaussures')
    collect_only_in_stock
  end

  def all_accessories
    @products = Product.where(category: 'accessoires')
    collect_only_in_stock
  end

  def all_offers
    @products = Product.where(former_price: (1..300))
    collect_only_in_stock
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
      save_variant_and_redirect
    else
      flash.now[:alert] = 'Référence introuvable sur Tamaris.com :('
      render :new
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

  def save_variant_and_redirect
    if @variant.save
      redirect_to product_path(@product.reference), notice: 'Produit ajouté :)'
    else
      flash.now[:alert] = 'Référence introuvable sur Tamaris.com :('
      render :new
    end
  end

  def collect_only_in_stock
    @products = @products.select(&:still_any_stock?)
  end
end
