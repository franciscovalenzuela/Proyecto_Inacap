# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141021004329) do

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "cities", ["name"], name: "city_name"
  add_index "cities", ["region_id"], name: "index_cities_on_region_id"
  add_index "cities", ["slug"], name: "index_cities_on_slug", unique: true

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name",            limit: 45,                 null: false
    t.datetime "date",                                       null: false
    t.integer  "producer_id",                                null: false
    t.integer  "city_id",                                    null: false
    t.string   "address",         limit: 45,                 null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "event_type_id",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sponsor",                    default: false
    t.integer  "event_status_id"
    t.text     "description"
    t.string   "place_name"
    t.string   "slug"
  end

  add_index "events", ["city_id"], name: "index_events_on_city_id"
  add_index "events", ["event_status_id"], name: "index_events_on_event_status_id"
  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id"
  add_index "events", ["producer_id"], name: "index_events_on_producer_id"
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "images", force: true do |t|
    t.string   "img_file_name", limit: 45
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "flayer",                   default: false
  end

  add_index "images", ["event_id"], name: "index_images_on_event_id"

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id"

  create_table "producer_roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "producers", force: true do |t|
    t.string   "name"
    t.string   "rut"
    t.string   "encrypted_password"
    t.string   "email"
    t.string   "adress"
    t.integer  "phone"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "producer_role_id"
    t.string   "api_key"
    t.integer  "merchant_id"
    t.integer  "account_id"
  end

  add_index "producers", ["city_id"], name: "index_producers_on_city_id"
  add_index "producers", ["email"], name: "index_producers_on_email", unique: true
  add_index "producers", ["producer_role_id"], name: "index_producers_on_producer_role_id"
  add_index "producers", ["reset_password_token"], name: "index_producers_on_reset_password_token", unique: true

  create_table "regions", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["country_id"], name: "index_regions_on_country_id"

  create_table "sections", force: true do |t|
    t.string   "name"
    t.integer  "price"
    t.datetime "from"
    t.datetime "to"
    t.boolean  "state"
    t.integer  "stock"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["event_id"], name: "index_sections_on_event_id"

  create_table "tickets", force: true do |t|
    t.integer  "section_id"
    t.boolean  "state"
    t.string   "qr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "tickets", ["section_id"], name: "index_tickets_on_section_id"
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id"

  create_table "transaction_states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "reference_code"
    t.integer  "user_id"
    t.integer  "section_id"
    t.integer  "quantity"
    t.integer  "price"
    t.string   "pol_response_code"
    t.string   "reference_pol"
    t.integer  "pol_payment_method_type"
    t.datetime "processing_date"
    t.string   "message"
    t.string   "merchant_name"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  add_index "transactions", ["section_id"], name: "index_transactions_on_section_id"
  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id"

  create_table "user_roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "run"
    t.integer  "user_role_id",                        null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "phone"
    t.string   "adress"
    t.integer  "city_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["user_role_id"], name: "index_users_on_user_role_id"

end
