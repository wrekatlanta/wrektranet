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

ActiveRecord::Schema.define(version: 20130804220744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_suggestions", force: true do |t|
    t.string   "name"
    t.datetime "date"
    t.string   "venue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests", force: true do |t|
    t.string   "name"
    t.datetime "date"
    t.integer  "venue_id"
    t.integer  "age_limit"
    t.boolean  "pick_up"
    t.integer  "listener_ticket_limit"
    t.integer  "staff_ticket_limit"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "listener_plus_one"
    t.boolean  "staff_plus_one"
  end

  add_index "contests", ["venue_id"], name: "index_contests_on_venue_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "staff_tickets", force: true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.integer  "contest_type"
    t.integer  "contest_director_id"
    t.boolean  "awarded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staff_tickets", ["user_id"], name: "index_staff_tickets_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                                        null: false
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "status"
    t.boolean  "admin"
    t.integer  "buzzcard_id"
    t.integer  "buzzcard_facility_code"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "venue_contacts", id: false, force: true do |t|
    t.integer  "venue_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venue_contacts", ["contact_id"], name: "index_venue_contacts_on_contact_id", using: :btree
  add_index "venue_contacts", ["venue_id"], name: "index_venue_contacts_on_venue_id", using: :btree

  create_table "venues", force: true do |t|
    t.string   "name"
    t.string   "fax"
    t.string   "address"
    t.integer  "send_day_offset"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "send_hour"
    t.integer  "send_minute"
  end

end
