class ProductsController < ApplicationController
  require 'open-uri'
  include Scraper

  before_action :set_product, only: [:create]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    @variant = Variant.new
  end

  def create
    if @product.nil?
      @product = Product.new(product_data(product_params[:reference]))
    end
    @variant = update_variant(product_params[:variants], @product)
    save_and_redirect
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
    if @product.save
      @variant.save
      redirect_to product_path(@product.reference), notice: 'Produit ajouté :)'
    else
      flash.now[:alert] = 'Produit introuvable sur Tamaris.com :('
      render :new
    end
  end
end
