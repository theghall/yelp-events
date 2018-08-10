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

ActiveRecord::Schema.define(version: 2018_08_10_194644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "oauth_provider"
    t.string "oauth_uid"
    t.string "oauth_name"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "yelp_events", force: :cascade do |t|
    t.string "yelp_event_id"
    t.string "business_id"
    t.string "name"
    t.string "description"
    t.string "display_address"
    t.string "image_url"
    t.string "start_date"
    t.string "start_time"
    t.boolean "cancelled"
    t.string "cost"
    t.boolean "is_free"
    t.boolean "tickets_required"
    t.string "tickets_url"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attending"
    t.bigint "user_id"
    t.string "end_date"
    t.string "end_time"
    t.index ["business_id"], name: "index_yelp_events_on_business_id"
    t.index ["category"], name: "index_yelp_events_on_category"
    t.index ["user_id"], name: "index_yelp_events_on_user_id"
    t.index ["yelp_event_id", "start_date"], name: "index_yelp_events_on_yelp_event_id_and_start_date", unique: true
  end

  add_foreign_key "yelp_events", "users"
end
