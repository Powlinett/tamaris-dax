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
