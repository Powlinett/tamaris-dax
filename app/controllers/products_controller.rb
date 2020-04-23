class ProductsController < ApplicationController
  require 'open-uri'

  before_action :set_product, only: [:show]

  def all_shoes
    @shoes = Product.where(category: 'chaussures')
  end

  def show
    @product_model = @product
    @photos_urls = @product_model.photos_urls
    @all_sizes = Product.where(reference: params[:reference])
  end

  def new
    @product = Product.new
  end

  def create
    @reference = product_params[:reference]

    scrap_product_page(@reference)

    @product = Product.create(
      reference: @reference,
      model: @model,
      category: @category,
      price: @price.to_f,
      size: product_params[:size].to_i,
      stock: product_params[:stock].to_i,
      photos_urls: @photos
    )

    redirect_to product_path(@product.reference)
  end

  private

  def to_param
    reference
  end

  def set_product
    @product = Product.find_by(reference: params[:reference])
  end

  def product_params
    params.require(:product).permit(:reference, :size, :stock)
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
    product_html = Nokogiri::HTML.parse(reference_page(reference))

    @category = product_html.search('.breadcrumb-element')[1].text.strip.downcase
    @model = product_html.search('h1').text.strip
    @price = product_html.search('.price-sales').text.split(' ').first.strip
    # @description = product_html.search('.information-wrapper')[0].text.strip

    # @photos = []
    @photos = product_html.search('.productthumbnail').map do |element|
      element.attribute('src').value.split('?')[0]
    end
    # @photos
  end
end
