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

require 'active_record/connection_adapters/mysql2_adapter'

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
end

ActiveRecord::Schema.define(version: 20150831205923) do

  create_table "calendars", force: true do |t|
    t.string   "url"
    t.string   "name"
    t.string   "default_location"
    t.integer  "weeks_to_show",    default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venue_id"
  end

  create_table "contest_suggestions", force: true do |t|
    t.string   "name"
    t.datetime "date"
    t.string   "venue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "archived",   default: false
    t.string   "show"
  end

  add_index "contest_suggestions", ["user_id"], name: "index_contest_suggestions_on_user_id", using: :btree

  create_table "contests", force: true do |t|
    t.integer  "venue_id"
    t.integer  "age_limit"
    t.boolean  "pick_up"
    t.integer  "listener_ticket_limit"
    t.integer  "staff_ticket_limit"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "listener_plus_one",      default: false
    t.boolean  "staff_plus_one",         default: false
    t.datetime "send_time"
    t.boolean  "sent",                   default: false
    t.integer  "staff_count"
    t.integer  "listener_count"
    t.integer  "alternate_recipient_id"
    t.string   "name"
    t.datetime "start_time"
    t.boolean  "public",                 default: true
  end

  add_index "contests", ["alternate_recipient_id"], name: "index_contests_on_alternate_recipient_id", using: :btree
  add_index "contests", ["venue_id"], name: "index_contests_on_venue_id", using: :btree

  create_table "legacy_bases", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listener_logs", force: true do |t|
    t.integer  "hd2_128"
    t.integer  "main_128"
    t.integer  "main_24"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listener_tickets", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "contest_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listener_tickets", ["contest_id"], name: "index_listener_tickets_on_contest_id", using: :btree
  add_index "listener_tickets", ["user_id"], name: "index_listener_tickets_on_user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.string   "action"
    t.string   "subject_class"
    t.integer  "subject_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "program_log_entries", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_log_entry_schedules", force: true do |t|
    t.integer  "program_log_entry_id"
    t.date     "start_date"
    t.date     "expiration_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "repeat_interval"
    t.boolean  "sunday",               default: false
    t.boolean  "monday",               default: false
    t.boolean  "tuesday",              default: false
    t.boolean  "wednesday",            default: false
    t.boolean  "thursday",             default: false
    t.boolean  "friday",               default: false
    t.boolean  "saturday",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_log_entry_schedules", ["program_log_entry_id"], name: "index_program_log_entry_schedules_on_program_log_entry_id", using: :btree

  create_table "program_log_schedules", force: true do |t|
    t.integer  "program_log_entry_id"
    t.date     "start_date"
    t.date     "expiration_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "repeat_interval",      default: 0
    t.boolean  "sunday",               default: false
    t.boolean  "monday",               default: false
    t.boolean  "tuesday",              default: false
    t.boolean  "wednesday",            default: false
    t.boolean  "thursday",             default: false
    t.boolean  "friday",               default: false
    t.boolean  "saturday",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_log_schedules", ["program_log_entry_id"], name: "index_program_log_schedules_on_program_log_entry_id", using: :btree

  create_table "psa_readings", force: true do |t|
    t.integer  "user_id"
    t.integer  "psa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "psas", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "status"
    t.date     "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_permissions", force: true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "role_permissions", ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
  add_index "role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "shows", force: true do |t|
    t.integer  "legacy_id"
    t.string   "name"
    t.string   "long_name"
    t.string   "short_name"
    t.string   "url"
    t.string   "description"
    t.string   "email"
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
  end

  add_index "shows", ["legacy_id"], name: "index_shows_on_legacy_id", unique: true, using: :btree

  create_table "staff_tickets", force: true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.integer  "contest_director_id"
    t.boolean  "awarded",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
  end

  add_index "staff_tickets", ["user_id"], name: "index_staff_tickets_on_user_id", using: :btree

  create_table "transmitter_log_entries", force: true do |t|
    t.datetime "sign_in"
    t.datetime "sign_out"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "automation_in",  default: false
    t.boolean  "automation_out", default: false
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                  null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                               null: false
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "status"
    t.boolean  "admin",                  default: false
    t.integer  "buzzcard_id"
    t.integer  "buzzcard_facility_code"
    t.integer  "legacy_id"
    t.string   "remember_token"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "middle_name"
    t.date     "birthday"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.boolean  "subscribed_to_staff"
    t.boolean  "subscribed_to_announce"
    t.string   "facebook"
    t.string   "spotify"
    t.string   "lastfm"
    t.integer  "points",                 default: 0
    t.boolean  "exec_staff",             default: false
  end

  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["legacy_id"], name: "index_users_on_legacy_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_id"], name: "index_users_on_user_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "venues", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "send_day_offset"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "send_hour"
  end

end
