class ProductsController < ApplicationController
  require 'open-uri'
  require 'csv'
  include ProductsHelper
  include Scraper

  before_action :set_product, only: [:create, :destroy]

  skip_before_action :authenticate_user!,
                     only: [:index, :show, :all_offers, :search, :index_by_sub_category]

  def index
    if params[:category] == 'promotions'
      @products = Product.where.not(former_price: 0.0)
    else
      @products = Product.where(category: params[:category])
    end
    @sub_categories = sub_categories_by_weight(params[:category])
    render_index_or_no_products
  end

  def index_by_sub_category
    if params[:category] == 'promotions'
      @products_by_category = Product.where.not(former_price: 0.0)
    else
      @products_by_category = Product.where(category: params[:category])
    end
    @sub_categories = sub_categories_by_weight(params[:category])
    @products = @products_by_category.where(sub_category: unslug(params[:sub_category]))
    render_index_or_no_products
  end

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

    if @product.save && @product.update_variant(variant_params)
      redirect_to product_path(@product.reference), notice: 'Produit ajouté :)'
    else
      flash.now[:alert] = 'Erreur lors de la récupération des données: merci de vérifier la référence et/ou la taille'
      render :new
    end
  end

  def destroy
    if @product.present?
      subtract_stock_to_variant
      redirect_to category_path(@product.category), notice: 'Produit supprimé.'
    else
      @product = Product.new
      flash.now[:alert] = 'Référence introuvable ou déjà supprimée'
      render :new
    end
  end

  def search
    @products = Product.search_in_products(params[:query])
    @sub_categories = sub_categories_for_results(@products)
    if @products.empty?
      render :no_results
    else
      paginate_products
      render :index
    end
  end

  def csv_import
    csv_options = { col_sep: ';', quote_char: '"', headers: :first_row }
    csv_file = params[:csv][:file].path

    CSV.foreach(csv_file, csv_options) do |row|
      product = Product.find_by(reference: "#{row[1]}-#{row[2]}")
      @variant = product.variants.find_by(size: row[3])
      stock_to_remove = row[0].to_i
      remove_stock(stock_to_remove)
    end
    redirect_to root_path, notice: 'Les stocks ont été modifiés'
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

  def find_variant(size)
    if (@product.category == 'accessoires') && (size == 1)
      @variant = @product.variants.first
    else
      @variant = @product.variants.find_by(size: size)
    end
  end

  def subtract_stock_to_variant
    find_variant(variant_params[:size].to_i)

    if @variant.present?
      remove_stock(variant_params[:stock].to_i)
    else
      false
    end
  end

  def remove_stock(stock_to_remove)
    if @variant.stock >= stock_to_remove
      @variant.update(stock: @variant.stock -= stock_to_remove)
    else
      @variant.update(stock: 0)
    end
  end

  def render_index_or_no_products
    if paginate_products.empty?
      render :no_products
    else
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
end
