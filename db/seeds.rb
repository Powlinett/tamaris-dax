# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.destroy_all

test_shoe1 = Product.create(
  reference: "1-1-22426-24-428",
  model: "escarpin",
  category: "chaussures",
  price: 49.95,
  size: 36,
  stock: 4,
  photos_urls: [
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_01.jpg',
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_02.jpg',
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_03.jpg',
    'https://tamaris.com/dw/image/v2/BBHF_PRD/on/demandware.static/-/Sites-tamaris-master-catalog/default/dw9dc8bd39/product-images/dw_001-19-22107-24-602_04.jpg'
  ]
)

test_shoe2 = Product.create(
  reference: "1-1-22426-24-428",
  model: "escarpin",
  category: "chaussures",
  price: 49.95,
  size: 37,
  stock: 4
  )
