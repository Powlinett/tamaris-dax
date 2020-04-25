Booking.destroy_all
Variant.destroy_all
Product.destroy_all

Product.create!(
  reference: "1-1-22426-24-428",
  model: "ballerine",
  category: "chaussures",
  price: 49.95,
  photos_urls: [
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_01.jpg',
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_02.jpg',
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_03.jpg',
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_04.jpg'
  ]
)

Product.create!(
  reference: "1-1-24216-24-444",
  model: "escarpin",
  category: "chaussures",
  price: 49.95
)

3.times do
  Variant.create!(
    size: rand(35..43),
    stock: rand(0..50),
    product: Product.all.sample
  )
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
