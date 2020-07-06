require 'open-uri'

# User.destroy_all
HomePage.destroy_all
Booking.destroy_all
Booker.destroy_all
Product.destroy_all
# Product.where(category: 'chaussures').destroy_all

# User.create(
#   email: 'test@test.com',
#   password: '123456'
# )

def scrap_all_products(category)
  main_url = "https://tamaris.com/fr-FR/#{category}"
  html = Nokogiri::HTML.parse(open(main_url))

  links = html.search('a.tile-link')
  links.each do |link|
    html = Nokogiri::HTML.parse(open(link['href']))
    reference = html.search('span.value')[0]
    next if reference.nil?

    reference = reference.text.strip
    product = product_data(reference)
    puts "Product is valid" if product.valid?
    product.save unless product.nil?
    unless product.persisted?
      puts "Product not saved"
      puts product.inspect
    end
    get_other_colors(reference, html)
  end
end

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

def retrieve_reference_page(reference)
  xml = get_reference_xml(reference)
  new_url = xml.at("meta[itemprop='url']").attr('content')

  html = Nokogiri::HTML.parse(open(new_url))
  scrap_product_page(html)
  get_product_color_and_photos(reference)
end

def get_reference_xml(reference)
  url = "https://tamaris.com/on/demandware.store/Sites-FR-Site/fr_FR/Product-Variation?pid=#{common_ref(reference)}&format=ajax&dwvar_#{common_ref(reference)}_color=#{color_ref(reference)}"
  Nokogiri::HTML.parse(open(url))
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

def product_data(reference)
  return nil if get_reference_page(reference).nil?

  product_features = ProductFeature.where(product_features(@raw_features))
                                    .first_or_create

  Product.new(
    reference: reference,
    category: @category.downcase,
    sub_category: @sub_category.downcase,
    model: @model,
    color: @color.downcase,
    price: @price.to_f,
    sizes_range: @sizes_array,
    former_price: @former_price.to_f,
    photos_urls: @photos.uniq,
    product_feature: product_features
  )
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

def get_other_colors(reference, html)
  xml = get_reference_xml(reference)
  colors = xml.search('masked-link.swatchanchor').map do |color|
    color.attr('data-color')
  end
  colors.each do |color|
    color_reference = common_ref(reference) + "-#{color}"
    product = product_data(color_reference)
    product.save unless product.nil?
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

def update_variants
  Product.all.each do |product|
    product.variants.each do |variant|
      variant.update(stock: rand(0..20))
    end
  end
end

def create_bookers
  30.times do
    email = Faker::Internet.email
    Booker.create!(
      email: email,
      email_confirmation: email,
      phone_number: "0612345678",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    )
  end
end

def create_bookings
  dates = (Date.today - 4 .. Date.today).to_a
  20.times do
    product = Product.all.sample
    Booking.create!(
      booker: Booker.all.sample,
      product: product,
      variant: product.variants.sample,
      starting_date: dates.sample
    )
  end
  Rake::Task['check_bookings'].invoke
end

scrap_all_products('chaussures')
scrap_all_products('accessoires')

update_variants
create_bookers
create_bookings

HomePage.create(product: Product.last)
