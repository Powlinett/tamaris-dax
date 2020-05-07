class ProductsController < ApplicationController
  require 'open-uri'
  include Scraper

  before_action :set_product, only: [:create]

  skip_before_action :authenticate_user!,
                     only: [:index, :show, :all_shoes, :all_accessories,
                            :all_offers, :search]

  def index
    @all_products = Product.all
    render_index_or_no_products
  end

  def all_shoes
    @all_products = Product.where(category: 'chaussures')
    render_index_or_no_products
  end

  def all_accessories
    @all_products = Product.where(category: 'accessoires')
    render_index_or_no_products
  end

  def all_offers
    @all_products = Product.where.not(former_price: 0.0)
    render_index_or_no_products
  end

  def new
    @product = Product.new
    @variant = Variant.new
  end

  def create
    if @product.nil?
      @product = Product.new(product_data(product_params[:reference]))
    end
    if @product.save && update_variant(product_params[:variants], @product)
      redirect_or_render_new
    else
      flash.now[:alert] = 'Référence introuvable sur Tamaris.com :('
      render :new
    end
  end

  def show
    @product = Product.find_by(reference: params[:reference])
    @other_colors = Product.where('reference like ?', "%#{@product.common_ref}%")
  end

  def search
    @all_products = Product.search_in_products(params[:query])
    if @all_products.empty?
      render :no_results
    else
      paginate_products
      render :index
    end
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

    if @variant.nil? || params[:stock].to_i.zero?
      @variant = Variant.new(
        size: params[:size].to_i,
        stock: params[:stock].to_i
      )
    else
      @variant.update(stock: params[:stock].to_i)
    end
  end

  def redirect_or_render_new
    if @variant.persisted?
      redirect_to product_path(@product.reference), notice: 'Produit ajouté :)'
    else
      flash.now[:alert] = 'Merci de vérifier la taille ou le stock'
      render :new
    end
  end

  def render_index_or_no_products
    if @all_products.empty?
      render :no_products
    else
      paginate_products
      render :index
    end
  end

  def collect_only_in_stock
    @all_products = @all_products.order(updated_at: :asc).select(&:still_any_stock?)
  end

  def paginate_products
    @products = Kaminari.paginate_array(collect_only_in_stock)
                        .page(params[:page])
  end
end
