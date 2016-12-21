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

ActiveRecord::Schema.define(version: 20161219030815) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.string   "renter"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "expected_earnings_cents",    default: 0,     null: false
    t.string   "expected_earnings_currency", default: "USD", null: false
    t.integer  "miles_included"
    t.string   "renter_photo"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "turo_reservation_id"
    t.index ["vehicle_id"], name: "index_reservations_on_vehicle_id", using: :btree
  end

  create_table "tolls", force: :cascade do |t|
    t.datetime "posted_at"
    t.datetime "occurred_at"
    t.string   "memo"
    t.string   "entry_plaza"
    t.string   "exit_plaza"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.integer  "vehicle_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["vehicle_id"], name: "index_tolls_on_vehicle_id", using: :btree
  end

  create_table "trips", force: :cascade do |t|
    t.string   "url"
    t.string   "remote_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.float    "distance"
    t.float    "duration"
    t.integer  "vehicle_id"
    t.text     "path"
    t.float    "fuel_cost_usd"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.jsonb    "start_location"
    t.jsonb    "start_address"
    t.jsonb    "end_location"
    t.jsonb    "end_address"
    t.float    "fuel_volume"
    t.string   "tags",                        array: true
    t.index ["vehicle_id"], name: "index_trips_on_vehicle_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "auth_token"
    t.string   "first_name"
    t.string   "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "make"
    t.string   "model"
    t.string   "year"
    t.integer  "odometer"
    t.string   "vin"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
    t.string   "remote_id"
    t.string   "photo"
    t.bigint   "edmunds_id"
    t.string   "transponder"
    t.integer  "turo_id"
  end

  create_table "webhooks", force: :cascade do |t|
    t.string   "integration"
    t.jsonb    "data"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "remote_id"
    t.string   "webhook_type"
    t.jsonb    "location"
    t.integer  "vehicle_id"
    t.index ["vehicle_id"], name: "index_webhooks_on_vehicle_id", using: :btree
  end

  add_foreign_key "reservations", "vehicles"
  add_foreign_key "trips", "vehicles"
  add_foreign_key "webhooks", "vehicles"
end
