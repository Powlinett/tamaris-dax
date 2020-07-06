module Scraper
  def get_reference_page(reference)
    url = "https://tamaris.com/fr-FR/recherche/?q=#{reference}&lang=fr_FR"
    html = Nokogiri::HTML.parse(open(url))

    if html.title.include?(common_ref(reference))
      scrap_product_page(html)
      get_product_color_and_photos(reference)
    else
      retrieve_reference_page(reference)
    end
  end

  def get_reference_xml(reference)
    url = "https://tamaris.com/on/demandware.store/Sites-FR-Site/fr_FR/Product-Variation?pid=#{common_ref(reference)}&format=ajax&dwvar_#{common_ref(reference)}_color=#{color_ref(reference)}"
    Nokogiri::HTML.parse(open(url))
  end

  def retrieve_reference_page(reference)
    xml = get_reference_xml(reference)
    new_url = xml.at("meta[itemprop='url']").attr('content')

    html = Nokogiri::HTML.parse(open(new_url))
    scrap_product_page(html)
    get_product_color_and_photos(reference)
  end

  def scrap_product_page(html)
    @category = html.search('.breadcrumb-element')[1].text.strip
    @sub_category = html.search('.breadcrumb-element')[2].text.strip
    @model = html.title.split('-')[0].strip[/\D*/].strip
    @price = html.search('.price-sales').first['data-sale-price']
    @former_price = html.search('.price-standard').text.split(' ')[0]
    unless @former_price.nil?
      @former_price = @former_price.strip.split(',').join('.')
    end
    @sizes_array = html.search('.selection').map { |s| s.text.strip.to_i }
    @raw_features = html.search('.info-table').text
    @raw_description = html.search('.long-description').text.split("\n")
  end

  def get_product_color_and_photos(reference)
    xml = get_reference_xml(reference)

    @color = xml.search('.product-variations .label').text.gsub('#', '').strip
    @photos = xml.search('.primary-image').map do |element|
      el = element.attr('src') || el = element.attr('data-src')
      el.split('?').first
    end
  end

  def common_ref(reference)
    ref_array = reference.split('-')
    ref_array = ref_array[0...-1]
    ref_array.join('-')
  end

  def color_ref(reference)
    ref_array = reference.split('-')
    ref_array = ref_array[-1]
  end

  def product_data(reference)
    return { reference: reference } if get_reference_page(reference).nil?

    product_features = ProductFeature.where(product_features(@raw_features))
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
        photos_urls: @photos.uniq,
        product_feature: product_features
      }
  end

  def product_features(features_text)
    features_array = features_text.split("\n").map do |x|
              x.gsub(':', '').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
            end
    features_array = features_array.reject { |x| x.empty? }

    features_hash = Hash[*features_array]
    features_hash.delete("Numéro d'article")

    @raw_description.empty? ? description = "" : description = @raw_description.last.strip

    @product_features =
      {
        features_hash: features_hash,
        description: description
      }
  end
end
