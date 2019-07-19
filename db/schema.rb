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

ActiveRecord::Schema.define(version: 2019_07_18_182216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "agency_name", null: false
    t.integer "priority", null: false
    t.index ["agency_name"], name: "index_agencies_on_agency_name", unique: true
  end

  create_table "agency_apartments", force: :cascade do |t|
    t.bigint "agency_id"
    t.bigint "apartment_id"
    t.decimal "price", precision: 8, scale: 2, null: false
    t.index ["agency_id", "apartment_id"], name: "index_agency_apartments_on_agency_id_and_apartment_id", unique: true
    t.index ["agency_id"], name: "index_agency_apartments_on_agency_id"
    t.index ["apartment_id"], name: "index_agency_apartments_on_apartment_id"
  end

  create_table "apartments", force: :cascade do |t|
    t.string "address", null: false
    t.string "apartment", null: false
    t.string "city", null: false
    t.index ["address", "apartment", "city"], name: "index_apartments_on_address_and_apartment_and_city", unique: true
  end

  add_foreign_key "agency_apartments", "agencies"
  add_foreign_key "agency_apartments", "apartments"
end
