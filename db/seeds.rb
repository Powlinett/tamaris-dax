require 'open-uri'

User.destroy_all
Booking.destroy_all
Booker.destroy_all
Variant.destroy_all
Product.destroy_all

def scrap_all_products
  main_url = 'https://tamaris.com/fr-FR/chaussures/'
  html = Nokogiri::HTML.parse(open(main_url))

  links = html.search('a.tile-link')
  links.each do |link|
    html = Nokogiri::HTML.parse(open(link['href']))
    reference = html.search('span.value')[0].text.strip
    product = product_data(reference)
    product.save unless product.nil?
    get_other_colors(reference, html)
  end
end

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
  @sizes_range = ((html.search('.selection').first.text.strip.to_i)..(html.search('.selection').last.text.strip.to_i))
  # @description = html.search('.information-wrapper')[0].text.strip

  @photos = html.search('.productthumbnail').map do |element|
    element.attribute('src').value.split('?')[0]
  end
end

def product_data(reference)
  return nil if get_reference_page(reference).nil?

  Product.new(
    reference: reference,
    category: @category.downcase,
    model: @model,
    color: @color.downcase,
    price: @price.to_f,
    sizes_range: @sizes_range,
    former_price: @former_price.to_f,
    photos_urls: @photos
  )
end

def get_other_colors(reference, html)
  model_ref = reference.split('-')[0..3].join('-')
  colors = html.search('masked-link.swatchanchor').map do |element|
    element.attribute('data-color').value
  end
  colors.each do |color|
    color_ref = model_ref + "-#{color}"
    product = product_data(color_ref)
    product.save
  end
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
  20.times do
    email = Faker::Internet.email
    Booker.create(
      email: email,
      email_confirmation: email,
      phone_number: Faker::PhoneNumber.phone_number,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    )
  end
end

def create_bookings
  10.times do
    product = Product.all.sample
    Booking.create(
      booker: Booker.all.sample,
      product: product,
      variant: product.variants.sample
    )
  end
end

User.create(
  email: 'test@test.com',
  password: '123456'
)

scrap_all_products

update_variants

create_bookers

create_bookings
