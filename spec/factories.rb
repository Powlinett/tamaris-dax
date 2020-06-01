FactoryBot.define do

  factory :product_feature do
    features_hash {
      {"Numéro d'article"=>"1-1-22107-24-001",
       "Hauteur de la tige"=>"6.5 cm",
       "Type de talon"=>"Talon bloc",
       "Hauteur du talon"=>"10 mm",
       "Semelle intérieure"=>"Cuir",
       "Extérieur"=>"Cuir",
       "Pointe de la chaussure"=>"bout rond",
       "Doublure"=>"Mélange de textile et synthétique"}
    }
    description {
      "Ces ballerine de Tamaris ne sont pas seulement chic..."
    }
  end

  factory :product do
    reference { "1-1-22107-24-602" }
    model { "Ballerine en cuir" }
    color { "sun" }
    category { "chaussures" }
    sub_category { "ballerines" }
    price { 59.95 }
    former_price { 0.0 }
    sizes_range { [35, 36, 37, 38, 39, 40, 41, 42] }
    product_feature { create(:product_feature) }
  end

  factory :variant do
    stock { 10 }
    size { 38 }
    product { build(:product) }
  end

  factory :booker do
    email { "johndoe@test.com" }
    email_confirmation { "johndoe@test.com" }
    phone_number { "0612345678" }
    first_name { "John" }
    last_name { "Doe" }
  end

  factory :booking do

    product { build(:product) }
    variant { product.variants.first }
    booker { build(:booker) }
  end
end
