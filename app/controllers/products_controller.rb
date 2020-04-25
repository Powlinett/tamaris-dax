class ProductsController < ApplicationController
  require 'open-uri'

  before_action :set_product, only: [:create]

  skip_before_action :authenticate_user!, only: [:all_shoes, :show]

  def all_shoes
    @shoes = Product.where(category: 'chaussures')
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
      scrap_product_page(ref_params)

      @product = Product.create(
        reference: ref_params,
        model: @model,
        category: @category.downcase,
        price: @price.to_f,
        former_price: @former_price.to_f,
        photos_urls: @photos
      )
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

  def ref_params
    product_params[:reference]
  end

  def reference_page(reference)
    main_url = 'https://tamaris.com'
    tamaris_data = Mechanize.new
    tamaris_data.get(main_url)
    tamaris_data.page.forms[0].field_with(id: 'q').value = reference

    product_page = tamaris_data.page.forms[0].submit
    open(main_url + product_page.uri.path)
  end

  def scrap_product_page(reference)
    html = Nokogiri::HTML.parse(reference_page(reference))

    @category = html.search('.breadcrumb-element')[1].text.strip
    @model = html.search('h1').text.strip
    @price = html.search('.price-sales').first['data-sale-price']
    @former_price = html.search('.price-standard').text.split(' ')[0]
    if @former_price.nil?
      @former_price = @former_price.strip.split(',').join('.')
    end
    # @description = product_html.search('.information-wrapper')[0].text.strip

    @photos = html.search('.productthumbnail').map do |element|
      element.attribute('src').value.split('?')[0]
    end
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
