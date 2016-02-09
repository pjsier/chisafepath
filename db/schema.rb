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

ActiveRecord::Schema.define(version: 20160208170706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  create_table "issues", force: :cascade do |t|
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "api_id"
    t.string    "api_token"
    t.string    "api_status"
    t.string    "service_code"
    t.text      "description"
    t.geography "lonlat",       limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "image_url"
  end

  create_table "issues_categories", id: false, force: :cascade do |t|
    t.integer "issue_id"
    t.integer "category_id"
  end

  add_index "issues_categories", ["category_id"], name: "index_issues_categories_on_category_id", using: :btree
  add_index "issues_categories", ["issue_id", "category_id"], name: "index_issues_categories_on_issue_id_and_category_id", using: :btree

end
