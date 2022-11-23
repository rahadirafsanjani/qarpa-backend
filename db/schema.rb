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

ActiveRecord::Schema[7.0].define(version: 2022_11_23_091401) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "addresses", force: :cascade do |t|
    t.string "full_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "check_in"
    t.datetime "check_out"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "username"
    t.string "bank"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_bank_accounts_on_company_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "address_id"
    t.boolean "status"
    t.string "phone"
    t.index ["address_id"], name: "index_branches_on_address_id"
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.bigint "company_id"
    t.string "email"
    t.index ["address_id"], name: "index_customers_on_address_id"
    t.index ["company_id"], name: "index_customers_on_company_id"
  end

  create_table "detail_orders", force: :cascade do |t|
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.bigint "product_shared_id"
    t.index ["order_id"], name: "index_detail_orders_on_order_id"
    t.index ["product_shared_id"], name: "index_detail_orders_on_product_shared_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "address_id"
    t.index ["address_id"], name: "index_inventories_on_address_id"
    t.index ["company_id"], name: "index_inventories_on_company_id"
  end

  create_table "item_shippings", force: :cascade do |t|
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shipping_id"
    t.bigint "product_shared_id"
    t.index ["product_shared_id"], name: "index_item_shippings_on_product_shared_id"
    t.index ["shipping_id"], name: "index_item_shippings_on_shipping_id"
  end

  create_table "leave_managements", force: :cascade do |t|
    t.string "title"
    t.string "notes"
    t.date "start_at"
    t.date "end_at"
    t.integer "leave_status", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_leave_managements_on_user_id"
  end

  create_table "management_works", force: :cascade do |t|
    t.string "task"
    t.text "description"
    t.date "start_at"
    t.date "end_at"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_management_works_on_company_id"
    t.index ["user_id"], name: "index_management_works_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id"
    t.bigint "pos_id"
    t.integer "discount"
    t.integer "payment"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["pos_id"], name: "index_orders_on_pos_id"
  end

  create_table "pos", force: :cascade do |t|
    t.integer "fund"
    t.string "notes"
    t.datetime "open_at"
    t.datetime "close_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.bigint "user_id"
    t.index ["branch_id"], name: "index_pos_on_branch_id"
    t.index ["user_id"], name: "index_pos_on_user_id"
  end

  create_table "product_shareds", force: :cascade do |t|
    t.integer "qty"
    t.integer "selling_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "supplier_id"
    t.string "parent_type"
    t.bigint "parent_id"
    t.date "expire"
    t.integer "purchase_price"
    t.index ["parent_type", "parent_id"], name: "index_product_shareds_on_parent"
    t.index ["product_id"], name: "index_product_shareds_on_product_id"
    t.index ["supplier_id"], name: "index_product_shareds_on_supplier_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "quantity_type"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "shippings", force: :cascade do |t|
    t.datetime "assign_at"
    t.bigint "destination_id", null: false
    t.bigint "origin_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id"
    t.integer "branch_id"
    t.index ["branch_id"], name: "index_shippings_on_branch_id"
    t.index ["customer_id"], name: "index_shippings_on_customer_id"
    t.index ["destination_id"], name: "index_shippings_on_destination_id"
    t.index ["origin_id"], name: "index_shippings_on_origin_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "address_id"
    t.string "phone"
    t.string "email"
    t.index ["address_id"], name: "index_suppliers_on_address_id"
    t.index ["company_id"], name: "index_suppliers_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "regist_token"
    t.datetime "regist_token_sent_at"
    t.datetime "confirmed_at"
    t.bigint "company_id"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "shippings", "addresses", column: "destination_id"
  add_foreign_key "shippings", "addresses", column: "origin_id"
end
