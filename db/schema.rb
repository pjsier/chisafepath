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

ActiveRecord::Schema.define(version: 20160604225216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "images", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: :cascade do |t|
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.datetime  "requested_datetime"
    t.datetime  "updated_datetime"
    t.string    "service_request_id"
    t.string    "status"
    t.string    "status_notes"
    t.string    "address"
    t.string    "description"
    t.string    "media_url"
    t.geography "lonlat",                 limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer   "image_id"
  end

  add_index "issues", ["image_id"], name: "index_issues_on_image_id", using: :btree
  add_index "issues", ["lonlat"], name: "index_issues_on_lonlat", using: :gist

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "level"
    t.geometry "geom",       limit: {:srid=>0, :type=>"geometry"}
  end

  add_index "locations", ["geom"], name: "index_locations_on_geom", using: :gist

end
