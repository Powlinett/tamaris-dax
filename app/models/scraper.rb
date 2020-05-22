module Scraper
  def get_reference_page(reference)
    url = "https://tamaris.com/fr-FR/recherche/?q=#{reference}&lang=fr_FR"
    html = Nokogiri::HTML.parse(open(url))

    if html.title.include?(reference)
      scrap_product_page(html)
    elsif html.search('.tile-link').last != nil
      new_url = html.search('.tile-link').last.attribute('href').value
      html = Nokogiri::HTML.parse(open(new_url))
      scrap_product_page(html)
    end
  end

  def scrap_product_page(html)
    @category = html.search('.breadcrumb-element')[1].text.strip
    @sub_category = html.search('.breadcrumb-element')[2].text.strip
    @model = html.title.split('-')[0].strip[/\D*/].strip
    @color = html.search('div.label').text.gsub('#', '').strip
    @price = html.search('.price-sales').first['data-sale-price']
    @former_price = html.search('.price-standard').text.split(' ')[0]
    unless @former_price.nil?
      @former_price = @former_price.strip.split(',').join('.')
    end
    @sizes_array = html.search('.selection').map { |s| s.text.strip.to_i }
    @raw_features = html.search('.info-table').text
    @description = html.search('.long-description').text.split("\n").last.strip

    @photos = html.search('.productthumbnail').map do |element|
      element.attribute('src').value.split('?')[0]
    end
  end

  def product_data(reference)
    return { reference: reference } if get_reference_page(reference).nil?

    @product_features = ProductFeature.where(product_features(@raw_features))
                                      .first_or_create

    @product_data =
      {
        reference: reference,
        category: @category.downcase,
        sub_category: @sub_category.downcase,
        model: @model,
        color: @color.downcase,
        price: @price.to_f,
        former_price: @former_price.to_f,
        sizes_range: @sizes_array,
        photos_urls: @photos,
        product_feature: @product_features
      }
  end

  def product_features(features_text)
    array = features_text.split("\n").map { |x| x.gsub(':', '').strip }
    array = array.reject { |x| x.empty? }

    @features_hash = Hash[*array]
    @product_features =
      {
        features_hash: @features_hash,
        description: @description
      }
  end
end
