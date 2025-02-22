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

ActiveRecord::Schema.define(version: 2025_02_21_225813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.boolean "force_close", default: false
    t.string "slug"
    t.text "scrambles"
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
    t.integer "value1", default: 0
    t.integer "value2", default: 0
    t.integer "value3", default: 0
    t.integer "value4", default: 0
    t.integer "value5", default: 0
    t.integer "best", default: 0
    t.integer "average", default: 0
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
    t.bigint "order_number"
    t.index ["order_number"], name: "index_subscriptions_on_order_number"
    t.index ["payed_at"], name: "index_subscriptions_on_payed_at"
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
    t.string "preferred_locale"
  end

  create_table "vote_answers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "vote_option_id"
    t.index ["user_id"], name: "index_vote_answers_on_user_id"
    t.index ["vote_option_id"], name: "index_vote_answers_on_vote_option_id"
  end

  create_table "vote_options", force: :cascade do |t|
    t.string "name"
    t.bigint "vote_id"
    t.index ["vote_id"], name: "index_vote_options_on_vote_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "name"
    t.boolean "visible"
    t.boolean "over"
    t.boolean "multiple_choices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
