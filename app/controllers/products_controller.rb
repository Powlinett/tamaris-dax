class ProductsController < ApplicationController
  require 'open-uri'
  include ProductsHelper
  include Scraper

  before_action :set_product, only: [:create, :destroy]

  skip_before_action :authenticate_user!,
                     only: [:index, :show, :all_offers, :search, :index_by_sub_category]

  def index
    if params[:category].nil?
      @products = Product.all
    elsif params[:category] == 'promotions'
      @products = Product.where.not(former_price: 0.0)
    else
      @products = Product.where(category: params[:category])
    end
    set_sub_categories
    render_index_or_no_products
  end

  def index_by_sub_category
    if params[:category] == 'promotions'
      @products_by_cat = Product.where.not(former_price: 0.0)
    else
      @products_by_cat = Product.where(category: params[:category])
    end
    @products = @products_by_cat.where(sub_category: unslug(params[:sub_category]))

    @sub_categories = @products_by_cat.pluck(:sub_category).uniq
    render_index_or_no_products
  end

  # def all_offers
  #   @products = Product.where.not(former_price: 0.0)
  #   set_sub_categories
  #   render_index_or_no_products
  # end

  def show
    @product = Product.find_by(reference: params[:reference])
    @other_colors = Product.where('reference like ?', "%#{@product.common_ref}%")
  end

  def new
    @product = Product.new
    @variant = Variant.new
  end

  def create
    if @product.nil?
      @product = Product.new(product_data(product_params[:reference].strip))
    end
    if @product.save && update_variant(variant_params, @product)
      redirect_or_render_new
    else
      flash.now[:alert] = 'Référence introuvable ou erreur lors de la récupération des données'
      render :new
    end
  end

  def destroy
    @variant = @product.variants.find_by(size: variant_params[:size].to_i)
    stock_to_remove = variant_params[:stock].to_i
    if @variant.stock >= stock_to_remove
      @variant.stock -= stock_to_remove
    else
      @variant.stock = 0
    end
    @variant.save ? (redirect_to category_path(@product.category)) : (render :new)
  end

  def search
    @products = Product.search_in_products(params[:query])
    if @products.empty?
      render :no_results
    else
      set_sub_categories
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

  def variant_params
    product_params[:variants]
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
    if @products.empty?
      render :no_products
    else
      paginate_products
      render :index
    end
  end

  def collect_only_in_stock
    @products = @products.order(updated_at: :desc)
                         .select(&:still_any_stock?)
  end

  def paginate_products
    @paginated_products = Kaminari.paginate_array(collect_only_in_stock)
                                  .page(params[:page])
  end

  def set_sub_categories
    @sub_categories = @products.pluck(:sub_category).uniq
  end
end
