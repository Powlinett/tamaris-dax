module Scraper
  def get_reference_page(reference)
    url = "https://tamaris.com/fr-FR/recherche/?q=#{reference}&lang=fr_FR"
    html = Nokogiri::HTML.parse(open(url))

    scrap_product_page(html) if html.title.include?(reference)
  end

  def scrap_product_page(html)
    @category = html.search('.breadcrumb-element')[1].text.strip
    @model = html.title.split('-')[0].strip[/\D*/]
    @color = html.search('div.label').text.strip
    @price = html.search('.price-sales').first['data-sale-price']
    @former_price = html.search('.price-standard').text.split(' ')[0]
    unless @former_price.nil?
      @former_price = @former_price.strip.split(',').join('.')
    end
    @sizes_available = ((html.search('.selection').first.text.strip.to_i)..(html.search('.selection').last.text.strip.to_i))
    # @description = product_html.search('.information-wrapper')[0].text.strip

    @photos = html.search('.productthumbnail').map do |element|
      {
        full_size: element.attribute('src').value.split('?')[0],
        thumbnail: element.attribute('src').value
      }
    end
  end

  def product_data(reference)
    return { reference: reference } if get_reference_page(reference).nil?

    @product_data =
      {
        reference: reference,
        category: @category.downcase,
        model: @model,
        color: @color.downcase,
        price: @price.to_f,
        former_price: @former_price.to_f,
        sizes_range: @sizes_available,
        photos_urls: @photos
      }
  end
end
