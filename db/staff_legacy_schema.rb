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

ActiveRecord::Schema.define(version: 0) do

  create_table "TaskMgt_Dep", id: false, force: true do |t|
    t.integer "id",  default: 0, null: false
    t.integer "dep", default: 0, null: false
    t.string  "txt"
  end

  create_table "TaskMgt_Tasks", force: true do |t|
    t.integer   "parent",                             default: 0,  null: false
    t.string    "title",                  limit: 128
    t.text      "details"
    t.integer   "owner"
    t.string    "resources",              limit: 64,  default: ""
    t.integer   "percent_completed",      limit: 2,   default: 0
    t.integer   "calc_percent_completed", limit: 2
    t.integer   "priority"
    t.integer   "bgt_money"
    t.integer   "bgt_time"
    t.integer   "act_money"
    t.integer   "act_time"
    t.date      "start"
    t.date      "end"
    t.timestamp "updated",                                         null: false
  end

  create_table "TaskMgt_Viewed", id: false, force: true do |t|
    t.integer   "user_id", default: 0, null: false
    t.integer   "task_id", default: 0, null: false
    t.timestamp "viewed",              null: false
  end

  create_table "addressinfo", force: true do |t|
    t.integer   "pid",                     default: 0, null: false
    t.string    "description", limit: 128
    t.string    "addr1",       limit: 64
    t.string    "addr2",       limit: 64
    t.string    "city",        limit: 64
    t.string    "state",       limit: 4
    t.string    "zip",         limit: 10
    t.string    "country",     limit: 32
    t.timestamp "updated",                             null: false
  end

  create_table "emailinfo", force: true do |t|
    t.integer   "pid",                    default: 0, null: false
    t.string    "description", limit: 64
    t.string    "addr",        limit: 64
    t.string    "stafflist",   limit: 1
    t.string    "annclist",    limit: 1
    t.timestamp "updated",                            null: false
    t.string    "pri",         limit: 1
  end

  create_table "fax", id: false, force: true do |t|
    t.string  "fax_id",   limit: 5
    t.integer "staff_id"
  end

  create_table "genre_relationships", id: false, force: true do |t|
    t.integer "genre_id", limit: 2
    t.integer "show_id",  limit: 2
    t.integer "order_id", limit: 2
  end

  add_index "genre_relationships", ["show_id", "genre_id"], name: "uc_relationship", unique: true, using: :btree

  create_table "genres", force: true do |t|
    t.string  "name",     limit: 100
    t.boolean "is_music",             default: true, null: false
  end

  add_index "genres", ["name"], name: "name", unique: true, using: :btree

  create_table "last_logon", id: false, force: true do |t|
    t.integer   "pid",                                 null: false
    t.timestamp "last_update",                         null: false
    t.string    "initials",    limit: 8,  default: "", null: false
    t.string    "fname",       limit: 32
    t.string    "lname",       limit: 32
  end

  create_table "lastlogon", primary_key: "pid", force: true do |t|
    t.timestamp "last_update", null: false
  end

  create_table "old_shows", force: true do |t|
    t.text      "name",      limit: 255
    t.text      "code",      limit: 255
    t.date      "created"
    t.text      "url"
    t.text      "email",     limit: 255
    t.text      "comments"
    t.timestamp "updated",               null: false
    t.integer   "leader_id"
    t.string    "show_type", limit: 16,  null: false
  end

  create_table "old_showsched", id: false, force: true do |t|
    t.integer "id"
    t.string  "day",       limit: 2
    t.time    "startdate"
    t.time    "killdate"
    t.time    "starttime"
    t.time    "duration"
  end

  create_table "phoneinfo", force: true do |t|
    t.integer   "pid",                    default: 0, null: false
    t.string    "description", limit: 32
    t.string    "number",      limit: 32
    t.timestamp "updated",                            null: false
    t.string    "pri",         limit: 1
  end

  create_table "photoinfo", force: true do |t|
    t.integer   "pid",         default: 0, null: false
    t.string    "url"
    t.date      "when_broken"
    t.timestamp "updated",                 null: false
  end

  create_table "points", force: true do |t|
    t.integer   "pid"
    t.text      "description"
    t.text      "details"
    t.integer   "requested"
    t.text      "comments"
    t.integer   "approverid"
    t.integer   "awarded"
    t.timestamp "posted",      null: false
    t.timestamp "updated",     null: false
  end

  create_table "pointterms", force: true do |t|
    t.string "title",  limit: 32
    t.date   "start"
    t.date   "end"
    t.string "closed", limit: 1
  end

  create_table "show_memberships", id: false, force: true do |t|
    t.integer "id",                            null: false
    t.integer "staff_id",          default: 0, null: false
    t.integer "specialty_show_id", default: 0, null: false
    t.text    "public_notes"
    t.text    "private_notes"
  end

  create_table "shows", force: true do |t|
    t.integer   "leader_id",                    default: 0
    t.string    "name",             limit: 100,             null: false
    t.string    "short_name",       limit: 8
    t.string    "url",              limit: 254
    t.text      "show_description"
    t.string    "show_type",        limit: 9
    t.string    "email",            limit: 254
    t.timestamp "updatedon",                                null: false
    t.integer   "updatedby"
    t.string    "forecolor",        limit: 45
    t.string    "backcolor",        limit: 45
    t.string    "long_name",        limit: 45
    t.string    "facebook",         limit: 254
    t.string    "twitter",          limit: 254
  end

  create_table "showsched", force: true do |t|
    t.integer   "show_id",                            null: false
    t.integer   "relation",               default: 0
    t.date      "start_date"
    t.date      "end_date"
    t.time      "start_time",                         null: false
    t.time      "end_time",                           null: false
    t.string    "days",       limit: 2,               null: false
    t.string    "frequency",  limit: 100
    t.string    "channel",    limit: 4
    t.timestamp "updatedon",                          null: false
    t.integer   "updatedby"
    t.string    "title",      limit: 64
  end

  create_table "staff", id: false, force: true do |t|
    t.integer   "id",                                         null: false
    t.string    "pfname",          limit: 32
    t.string    "fname",           limit: 32
    t.string    "mname",           limit: 32
    t.string    "lname",           limit: 32
    t.date      "birthday"
    t.text      "private"
    t.text      "public"
    t.string    "position",        limit: 128
    t.string    "officehours",     limit: 128
    t.string    "initials",        limit: 8,   default: "",   null: false
    t.string    "status",          limit: 9
    t.string    "standing",        limit: 10
    t.string    "contestprivs",    limit: 3,   default: "no", null: false
    t.text      "sublist"
    t.string    "password",        limit: 16
    t.string    "admin",           limit: 1
    t.string    "exec",            limit: 1
    t.date      "joined"
    t.timestamp "updated",                                    null: false
    t.integer   "md_privileges",   limit: 1,   default: 0
    t.integer   "auto_privileges", limit: 1,   default: 0
    t.text      "specialtyshow"
    t.integer   "buzzcard_id",     limit: 3
    t.integer   "buzzcard_fc",     limit: 2
    t.string    "door1_access",    limit: 1
    t.string    "door2_access",    limit: 1
    t.string    "door3_access",    limit: 1
    t.string    "door4_access",    limit: 1
  end

  create_table "team_memberships", id: false, force: true do |t|
    t.integer "id",                        null: false
    t.integer "staff_id",      default: 0, null: false
    t.integer "team_id",       default: 0, null: false
    t.text    "public_notes"
    t.text    "private_notes"
  end

  create_table "teams", force: true do |t|
    t.string  "name",      limit: 32
    t.integer "leader_id"
  end

  create_table "todo", force: true do |t|
    t.text      "title"
    t.integer   "creator"
    t.integer   "owner"
    t.text      "description"
    t.string    "status",      limit: 32
    t.string    "category",    limit: 32
    t.integer   "priority"
    t.timestamp "lastupdate",             null: false
    t.timestamp "created",                null: false
  end

  create_table "todo_notes", force: true do |t|
    t.integer   "todo",                   default: 0, null: false
    t.string    "author",      limit: 64
    t.text      "content"
    t.timestamp "when_broken",                        null: false
  end

  create_table "webinfo", force: true do |t|
    t.integer   "pid",         default: 0, null: false
    t.string    "description"
    t.string    "url"
    t.timestamp "updated",                 null: false
  end

end
