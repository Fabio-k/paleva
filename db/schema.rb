# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_21_123133) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "cpf"
    t.string "name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "beverages", force: :cascade do |t|
    t.boolean "is_alcoholic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_hours", force: :cascade do |t|
    t.integer "day_of_week"
    t.time "opening_hour"
    t.time "closing_hour"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_business_hours_on_restaurant_id"
  end

  create_table "caracteristics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id"
    t.index ["restaurant_id"], name: "index_caracteristics_on_restaurant_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_pre_registrations", force: :cascade do |t|
    t.string "cpf"
    t.string "email"
    t.boolean "is_used", default: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_employee_pre_registrations_on_restaurant_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "cpf", null: false
    t.string "name"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_employees_on_restaurant_id"
  end

  create_table "item_caracteristics", force: :cascade do |t|
    t.integer "caracteristic_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caracteristic_id"], name: "index_item_caracteristics_on_caracteristic_id"
    t.index ["item_id"], name: "index_item_caracteristics_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "type"
    t.string "calories"
    t.integer "restaurant_id", null: false
    t.boolean "is_active", default: true
    t.boolean "is_alcoholic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_removed", default: false
    t.index ["restaurant_id"], name: "index_items_on_restaurant_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_menu_items_on_item_id"
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "order_portions", force: :cascade do |t|
    t.string "note"
    t.integer "order_id", null: false
    t.integer "portion_id", null: false
    t.integer "quantity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price", default: 1
    t.index ["order_id"], name: "index_order_portions_on_order_id"
    t.index ["portion_id"], name: "index_order_portions_on_portion_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_statuses_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.string "client_name"
    t.string "phone_number"
    t.string "email"
    t.string "cpf"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_price"
    t.string "reason_message"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "portion_prices", force: :cascade do |t|
    t.integer "price"
    t.integer "portion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portion_id"], name: "index_portion_prices_on_portion_id"
  end

  create_table "portions", force: :cascade do |t|
    t.string "description"
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.index ["item_id"], name: "index_portions_on_item_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "code"
    t.string "brand_name"
    t.string "corporate_name"
    t.string "registration_number"
    t.string "street"
    t.string "address_number"
    t.string "city"
    t.string "state"
    t.string "cep"
    t.string "phone_number"
    t.string "email"
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_restaurants_on_admin_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "business_hours", "restaurants"
  add_foreign_key "caracteristics", "restaurants"
  add_foreign_key "employee_pre_registrations", "restaurants"
  add_foreign_key "employees", "restaurants"
  add_foreign_key "item_caracteristics", "caracteristics"
  add_foreign_key "item_caracteristics", "items"
  add_foreign_key "items", "restaurants"
  add_foreign_key "menu_items", "items"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "restaurants"
  add_foreign_key "order_portions", "orders"
  add_foreign_key "order_portions", "portions"
  add_foreign_key "order_statuses", "orders"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "portion_prices", "portions"
  add_foreign_key "portions", "items"
  add_foreign_key "restaurants", "admins"
end
