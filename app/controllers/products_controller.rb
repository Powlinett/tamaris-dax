class ProductsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  before_action :set_product, only: [:show]

  def all_shoes
    @shoes = Product.where(category: 'chaussures')
  end

  def show
    @product
  end

  def new
    @product = Product.new
  end

  def create
    @reference = params[:reference]

    scrap_product_page(@reference)

    @product = Product.create(
      reference: @reference,
      category:
      )
  end

  def update

  end


  private

  def set_product
    @product = Product.find(params[:reference])
  end

  def page_for_reference(reference)
    reference = "1-1-22494-24-341"

    main_url = 'https://tamaris.com'
    tamaris_data = Mechanize.new
    tamaris_data.get(main_url)
    tamaris_data.page.forms[0].field_with(id: 'q').value = reference

    product_page = tamaris_data.page.forms[0].submit

    open(main_url + product_page.uri.path).read
  end

  def scrap_product_page(reference)
    product_html = Nokogiri::HTML(page_for_reference(reference))

    @reference = reference
    @category = product_html.search('.breadcrumb-element')[1].text.strip
    @description = product_html.search('.information-wrapper')[0].text.strip

    @photos = []
    product_html.search('.productthumbnail').each do |element|
      @photos << element.attribute('src').value.split('?')[0]
    end
    @photos
  end
end
