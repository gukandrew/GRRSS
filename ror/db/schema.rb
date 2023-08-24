# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_24_132431) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feeds", force: :cascade do |t|
    t.string "url"
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "title"
    t.string "source"
    t.string "source_url"
    t.string "link"
    t.datetime "published_at"
    t.text "description"
    t.bigint "feed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_items_on_feed_id"
    t.index ["published_at"], name: "index_items_on_published_at"
    t.index ["source"], name: "index_items_on_source"
    t.index ["source_url"], name: "index_items_on_source_url"
    t.index ["title", "source"], name: "index_items_on_title_and_source", unique: true
    t.index ["title"], name: "index_items_on_title"
  end

  add_foreign_key "items", "feeds"
end
