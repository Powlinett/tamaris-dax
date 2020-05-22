ActiveRecord::Schema.define(version: 2020_05_22_173911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookers", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.date "starting_date"
    t.date "ending_date"
    t.string "former_state"
    t.string "actual_state"
    t.bigint "booker_id"
    t.bigint "product_id"
    t.bigint "variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booker_id"], name: "index_bookings_on_booker_id"
    t.index ["product_id"], name: "index_bookings_on_product_id"
    t.index ["variant_id"], name: "index_bookings_on_variant_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "product_features", force: :cascade do |t|
    t.string "features_hash"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "reference"
    t.string "model"
    t.string "color"
    t.string "category"
    t.string "sub_category"
    t.float "price"
    t.float "former_price"
    t.text "sizes_range"
    t.text "photos_urls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_feature_id"
    t.index ["product_feature_id"], name: "index_products_on_product_feature_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.integer "size"
    t.integer "stock", default: 0
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "bookings", "bookers"
  add_foreign_key "bookings", "products"
  add_foreign_key "bookings", "variants"
  add_foreign_key "products", "product_features"
  add_foreign_key "variants", "products"
end
