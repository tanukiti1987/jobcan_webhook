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

ActiveRecord::Schema.define(version: 2017_11_03_161500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string "client_name", null: false
    t.string "user_name", null: false
    t.string "password", null: false
    t.string "salt", null: false
    t.string "access_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret_key"
    t.index ["access_key"], name: "index_authentications_on_access_key"
  end

  create_table "slack_notifications", force: :cascade do |t|
    t.integer "authentication_id", null: false
    t.string "webhook_url", null: false
    t.string "channel", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
