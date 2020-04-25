module Scraper
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
    unless @former_price.nil?
      @former_price = @former_price.strip.split(',').join('.')
    end
    # @description = product_html.search('.information-wrapper')[0].text.strip

    @photos = html.search('.productthumbnail').map do |element|
      {
        full_size: element.attribute('src').value.split('?')[0],
        thumbnail: element.attribute('src').value
      }
    end
  end

  def product_data(reference)
    scrap_product_page(reference)

    @product_data =
      {
        reference: reference,
        model: @model,
        category: @category.downcase,
        price: @price.to_f,
        former_price: @former_price.to_f,
        photos_urls: @photos
      }
  end
end
