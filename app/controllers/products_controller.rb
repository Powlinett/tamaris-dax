class ProductsController < ApplicationController
  require 'open-uri'

  include Scraper

  before_action :set_product, only: [:create]

  skip_before_action :authenticate_user!, only: [:all_shoes, :show]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(reference: params[:reference])
  end

  def new
    @product = Product.new
  end

  def create
    if !@product.nil?
      update_or_assign_variant(product_params[:variants], @product)
    else
      @product = Product.create(product_data(product_params[:reference]))

      assign_variant(product_params[:variants], @product)
    end
    redirect_to product_path(@product.reference)
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

  def update_or_assign_variant(params, product)
    if product.variants.any?
      variant = product.variants.find { |v| v.size == params[:size].to_i }
      if !variant.nil?
        variant.update_size_stock(variant.id, params[:stock].to_i)
      else
        assign_variant(params, product)
      end
    else
      assign_variant(params, product)
    end
  end

  def assign_variant(params, product)
    Variant.create(
      size: params[:size],
      stock: params[:stock],
      product: product
    )
  end
end
