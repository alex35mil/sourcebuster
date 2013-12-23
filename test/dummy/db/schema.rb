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

ActiveRecord::Schema.define(version: 20131223200512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sourcebuster_referer_sources", force: true do |t|
    t.string   "domain",              null: false
    t.string   "source_alias"
    t.integer  "referer_type_id",     null: false
    t.string   "organic_query_param"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sourcebuster_referer_sources", ["domain"], name: "index_sourcebuster_referer_sources_on_domain", using: :btree
  add_index "sourcebuster_referer_sources", ["organic_query_param"], name: "index_sourcebuster_referer_sources_on_organic_query_param", using: :btree
  add_index "sourcebuster_referer_sources", ["referer_type_id"], name: "index_sourcebuster_referer_sources_on_referer_type_id", using: :btree

  create_table "sourcebuster_referer_types", force: true do |t|
    t.string   "referer_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sourcebuster_referer_types", ["referer_type"], name: "index_sourcebuster_referer_types_on_referer_type", unique: true, using: :btree

end
