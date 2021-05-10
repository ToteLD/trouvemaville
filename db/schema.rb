# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_10_144902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "photo"
    t.integer "population"
    t.integer "commodity_count"
    t.integer "house_marketprice"
    t.boolean "primary_school"
    t.boolean "secondary_school"
    t.boolean "doctor"
    t.integer "age_average"
    t.boolean "supermarket"
    t.integer "land_marketprice"
    t.integer "flat_marketprice"
    t.float "latitude"
    t.float "longitude"
    t.string "fibre"
    t.string "network"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorite_cities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_favorite_cities_on_city_id"
    t.index ["user_id"], name: "index_favorite_cities_on_user_id"
  end

  create_table "saved_searches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "budget_max"
    t.boolean "primary_school"
    t.boolean "secondary_school"
    t.integer "age_average"
    t.boolean "supermarket"
    t.boolean "network"
    t.boolean "fibre"
    t.integer "min_surface"
    t.integer "max_distance_km"
    t.integer "max_distance_minutes"
    t.string "property_type"
    t.string "start_city"
    t.boolean "doctor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_saved_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorite_cities", "cities"
  add_foreign_key "favorite_cities", "users"
  add_foreign_key "saved_searches", "users"
end
