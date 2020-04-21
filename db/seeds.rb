# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.destroy_all

test_shoe = Product.create(
  reference: "1-1-22426-24-428",
  model: "escarpin",
  category: "shoe",
  price: 49.95,
  size: 36,
  stock: 4
  )
