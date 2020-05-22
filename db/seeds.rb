require 'open-uri'

# User.destroy_all
Booking.destroy_all
Booker.destroy_all
Variant.destroy_all
Product.destroy_all

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
    product.save unless product.nil?
    get_other_colors(reference, html)
  end
end

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
  @model = html.title.split('-')[0].strip[/\D*/]
  @color = html.search('div.label').text.gsub('#', '').strip
  @price = html.search('.price-sales').first['data-sale-price']
  @former_price = html.search('.price-standard').text.split(' ')[0]
  unless @former_price.nil?
    @former_price = @former_price.strip.split(',').join('.')
  end
  @sizes_array = html.search('.selection').map { |s| s.text.strip.to_i }
  @raw_features = html.search('.info-table').text
  @description = html.search('.long-description').text.split("\n").last

  @photos = html.search('.productthumbnail').map do |element|
    element.attribute('src').value.split('?')[0]
  end
end

def product_data(reference)
  return nil if get_reference_page(reference).nil?

  @product_features = ProductFeature.where(product_features(@raw_features))
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
    photos_urls: @photos,
    product_feature: @product_features
  )
end

def product_features(features_text)
  array = features_text.split("\n").map do |x|
            x.gsub(':', '').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
          end
  array = array.reject { |x| x.empty? }

  @features_hash = Hash[*array]
  @product_features =
    {
      features_hash: @features_hash,
      description: @description
    }
end

def get_other_colors(reference, html)
  model_ref = model_reference(reference)
  colors = html.search('masked-link.swatchanchor').map do |element|
    element.attribute('data-color').value
  end
  colors.each do |color|
    color_ref = model_ref + "-#{color}"
    product = product_data(color_ref)
    product.save unless product.nil?
  end
end

def model_reference(reference)
  ref_array = reference.split('-')
  ref_array = ref_array.reject { |x| ref_array.index(x) == ref_array.index(ref_array.last) }
  ref_array.join('-')
end

def update_variants
  Product.all.each do |product|
    product.variants.each do |variant|
      variant.update_stock(rand(0..20))
      variant.save
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
