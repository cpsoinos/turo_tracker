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

ActiveRecord::Schema.define(version: 20170108031035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.string   "category"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "date"
    t.string   "receipt"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["vehicle_id"], name: "index_expenses_on_vehicle_id", using: :btree
  end

  create_table "renters", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "photo"
    t.string "turo_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.string   "renter"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "expected_earnings_cents",    default: 0,     null: false
    t.string   "expected_earnings_currency", default: "USD", null: false
    t.integer  "miles_included"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "turo_reservation_id"
    t.integer  "reimbursements_cents",       default: 0,     null: false
    t.string   "reimbursements_currency",    default: "USD", null: false
    t.integer  "renter_id"
    t.index ["renter_id"], name: "index_reservations_on_renter_id", using: :btree
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
    t.boolean  "expensed"
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
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "url"
    t.string   "remote_id"
    t.string   "photo"
    t.bigint   "edmunds_id"
    t.string   "transponder"
    t.integer  "turo_id"
    t.integer  "loan_payment_cents",         default: 0,     null: false
    t.string   "loan_payment_currency",      default: "USD", null: false
    t.integer  "insurance_payment_cents",    default: 0,     null: false
    t.string   "insurance_payment_currency", default: "USD", null: false
    t.integer  "parking_payment_cents",      default: 0,     null: false
    t.string   "parking_payment_currency",   default: "USD", null: false
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
    t.float    "latitude"
    t.float    "longitude"
    t.index ["vehicle_id"], name: "index_webhooks_on_vehicle_id", using: :btree
  end

  add_foreign_key "expenses", "vehicles"
  add_foreign_key "reservations", "renters"
  add_foreign_key "reservations", "vehicles"
  add_foreign_key "trips", "vehicles"
  add_foreign_key "webhooks", "vehicles"
end
