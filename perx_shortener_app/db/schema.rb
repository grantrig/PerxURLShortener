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

ActiveRecord::Schema.define(version: 20170330133142) do

  create_table "api_credentials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "api_key"
    t.string   "api_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shortened_url_hits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "shortened_url_id"
    t.string   "user_agent"
    t.string   "referer"
    t.string   "ip_address"
    t.string   "accept_language"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "shortened_urls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "short_code",                     null: false
    t.string   "url",               limit: 1000, null: false
    t.integer  "api_credential_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["api_credential_id"], name: "index_shortened_urls_on_api_credential_id", using: :btree
    t.index ["short_code"], name: "index_shortened_urls_on_short_code", using: :btree
  end

end
