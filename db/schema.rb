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

ActiveRecord::Schema.define(version: 20200320212237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendar_events", force: :cascade do |t|
    t.string "name"
    t.boolean "public"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "email"
    t.text "description"
    t.string "logo"
    t.bigint "department_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "facebook"
    t.index ["department_id"], name: "index_clubs_on_department_id"
  end

  create_table "competitions", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "city"
    t.date "start_date"
    t.date "end_date"
    t.string "country_iso2"
    t.string "website"
    t.string "delegates"
    t.string "organizers"
    t.datetime "announced_at"
    t.index ["id"], name: "index_competitions_on_id", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_departments_on_region_id"
  end

  create_table "events", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "preferred_format"
    t.integer "rank"
    t.index ["id"], name: "index_events_on_id"
  end

  create_table "external_resources", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.text "description"
    t.string "img"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formats", id: :string, force: :cascade do |t|
    t.string "name"
    t.integer "expected_solve_count"
    t.string "sort_by"
    t.string "sort_by_second"
    t.integer "trim_fastest_n"
    t.integer "trim_slowest_n"
    t.index ["id"], name: "index_formats_on_id"
  end

  create_table "hardwares", force: :cascade do |t|
    t.string "name", null: false
    t.string "hardware_type", null: false
    t.string "comment"
    t.string "state", null: false
    t.bigint "bag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bag_id"], name: "index_hardwares_on_bag_id"
  end

  create_table "major_comps", force: :cascade do |t|
    t.string "competition_id"
    t.string "role"
    t.string "name"
    t.text "alt_text"
    t.index ["role"], name: "index_major_comps_on_role", unique: true
  end

  create_table "online_competitions", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.integer "user_id", null: false
    t.date "start", null: false
    t.date "end", null: false
    t.index ["item_type", "item_id"], name: "index_owners_on_item_type_and_item_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "tag_name", null: false
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_name", "post_id"], name: "index_post_tags_on_tag_name_and_post_id", unique: true
    t.index ["tag_name"], name: "index_post_tags_on_tag_name"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "body"
    t.string "slug", null: false
    t.boolean "feature", default: false, null: false
    t.bigint "user_id", null: false
    t.boolean "draft", default: true, null: false
    t.boolean "competition_page", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "posted_at"
    t.index ["slug"], name: "index_posts_on_slug"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "value1"
    t.integer "value2"
    t.integer "value3"
    t.integer "value4"
    t.integer "value5"
    t.integer "best"
    t.integer "average"
    t.string "event_id"
    t.string "format_id"
    t.bigint "user_id"
    t.bigint "online_competition_id"
    t.index ["event_id"], name: "index_results_on_event_id"
    t.index ["format_id"], name: "index_results_on_format_id"
    t.index ["online_competition_id"], name: "index_results_on_online_competition_id"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "firstname"
    t.string "wca_id"
    t.string "email"
    t.datetime "payed_at"
    t.string "receipt_url"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
    t.index ["wca_id"], name: "index_subscriptions_on_wca_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "color"
    t.string "fullname"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "wca_id"
    t.string "country_iso2"
    t.string "email"
    t.string "avatar_url"
    t.string "avatar_thumb_url"
    t.string "gender"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "delegate_status"
    t.boolean "admin", default: false
    t.boolean "communication", default: false
    t.boolean "french_delegate", default: false
    t.boolean "notify_subscription", default: false
    t.string "city"
    t.boolean "discussion_subscription"
    t.boolean "newsletter_subscription"
  end

end
