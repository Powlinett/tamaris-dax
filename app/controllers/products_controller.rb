class ProductsController < ApplicationController

  # def scrap_data_for_reference(model, reference)
  #   require 'nokogiri'
  #   require 'open-uri'

  #   @model = model_for_url(model)
  #   @reference = reference_for_url(reference)

  #   url = "https://tamaris.com/fr-FR/#{@model}/#{@reference}"
  #   product_page_html = Nokogiri::HTML(open(url))
  # end
  private

  def mechanize_scrap_by_ref(reference)
    require 'nokogiri'
    require 'open-uri'

    reference = "1-1-22494-24-341"

    main_url = 'https://tamaris.com/fr-FR/'
    tamaris_data = Mechanize.new

    tamaris_data.get(main_url)
    tamaris_data.page.forms[0].field_with(id: 'q').value = reference
    product_url = tamaris_data.page.forms[0].submit

    # description = product_url.search('.information-wrapper').text
    # category = product_url.search('.breadcrumb-element')[1].text.strip

    # photos_urls = []
    # product_url.search('.productthumbnail').attribute('src').value
end
