class ProductsController < ApplicationController
  require 'open-uri'

  before_action :set_product, only: [:show]

  def all_shoes
    @shoes = Product.where(category: 'chaussures')
  end

  def show
    @product_model = @product
    @all_sizes = Product.where(reference: params[:reference])
  end

  def new
    @product = Product.new
  end

  def create
    @reference = product_params

    scrap_product_page(@reference)

    @product = Product.create(reference: @reference)

    redirect_to product_path(@product)
  end

  private

  def to_param
    reference
  end

  def set_product
    @product = Product.where(reference: params[:reference]).first
  end

  def product_params
    params.require(:product).permit(:reference)
  end

  def page_for_reference(reference)
    main_url = 'https://tamaris.com'
    tamaris_data = Mechanize.new
    tamaris_data.get(main_url)
    tamaris_data.page.forms[0].field_with(id: 'q').value = reference

    product_page = tamaris_data.page.forms[0].submit

    open(main_url + product_page.uri.path)
  end

  def scrap_product_page(reference)
    product_html = Nokogiri::HTML.parse(page_for_reference(reference))

    @reference = reference
    # @category = product_html.search('.breadcrumb').children[5].text.strip
    # @description = product_html.search('.information-wrapper')[0].text.strip

    # @photos = []
    # product_html.search('.productthumbnail').each do |element|
    #   @photos << element.attribute('src').value.split('?')[0]
    # end
    # @photos
  end
end
