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

ActiveRecord::Schema.define(version: 20170403040905) do

  create_table "api_credentials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "api_key"
    t.string   "api_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_api_credentials_on_api_key", unique: true, using: :btree
  end

  create_table "browser_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_browser_types_on_name", unique: true, using: :btree
  end

  create_table "browser_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "browser_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["browser_type_id"], name: "index_browser_versions_on_browser_type_id", using: :btree
    t.index ["name", "browser_type_id"], name: "index_browser_versions_on_name_and_browser_type_id", unique: true, using: :btree
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_devices_on_name", unique: true, using: :btree
  end

  create_table "operating_system_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "operating_system_id"
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["name", "operating_system_id"], name: "index_operating_system_versions_on_name_and_operating_system_id", unique: true, using: :btree
  end

  create_table "operating_systems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_operating_systems_on_name", unique: true, using: :btree
  end

  create_table "shortened_url_hits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "shortened_url_id"
    t.string   "user_agent"
    t.string   "referer",                     limit: 1000
    t.string   "ip_address"
    t.string   "accept_language"
    t.integer  "operating_system_version_id"
    t.integer  "browser_version_id"
    t.integer  "device_id"
    t.string   "url",                         limit: 1000
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["browser_version_id"], name: "index_shortened_url_hits_on_browser_version_id", using: :btree
    t.index ["device_id"], name: "index_shortened_url_hits_on_device_id", using: :btree
    t.index ["operating_system_version_id"], name: "index_shortened_url_hits_on_operating_system_version_id", using: :btree
    t.index ["shortened_url_id"], name: "index_shortened_url_hits_on_shortened_url_id", using: :btree
  end

  create_table "shortened_urls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "short_code",                     null: false
    t.string   "url",               limit: 1000, null: false
    t.integer  "api_credential_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["api_credential_id"], name: "index_shortened_urls_on_api_credential_id", using: :btree
    t.index ["short_code"], name: "index_shortened_urls_on_short_code", unique: true, using: :btree
  end

end
