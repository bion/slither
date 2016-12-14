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

ActiveRecord::Schema.define(version: 20161123235036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_networks", force: :cascade do |t|
    t.integer "similar_web_id", null: false
    t.string  "name",           null: false
    t.float   "percent_served", null: false
    t.index ["similar_web_id"], name: "index_ad_networks_on_similar_web_id", using: :btree
  end

  create_table "adsense_id_records", force: :cascade do |t|
    t.integer "pull_id",    null: false
    t.string  "adsense_id", null: false
    t.index ["pull_id"], name: "index_adsense_id_records_on_pull_id", using: :btree
  end

  create_table "alexa_records", force: :cascade do |t|
    t.integer "pull_id",      null: false
    t.integer "global_rank",  null: false
    t.integer "country_rank", null: false
    t.index ["pull_id"], name: "index_alexa_records_on_pull_id", using: :btree
  end

  create_table "country_ranks", force: :cascade do |t|
    t.integer "similar_web_id", null: false
    t.integer "country_number", null: false
    t.integer "rank",           null: false
    t.integer "rank_delta",     null: false
    t.index ["similar_web_id"], name: "index_country_ranks_on_similar_web_id", using: :btree
  end

  create_table "entities", force: :cascade do |t|
    t.string "url",  null: false
    t.string "kind", null: false
    t.string "name"
    t.index ["url"], name: "index_entities_on_url", using: :btree
  end

  create_table "external_links", force: :cascade do |t|
    t.string   "url",        null: false
    t.string   "domain",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "pull_id",    null: false
    t.integer  "entity_id"
    t.index ["domain"], name: "index_external_links_on_domain", using: :btree
  end

  create_table "facebook_records", force: :cascade do |t|
    t.integer "pull_id",      null: false
    t.integer "shares",       null: false
    t.string  "og_object_id", null: false
    t.string  "facebook_id",  null: false
    t.index ["pull_id"], name: "index_facebook_records_on_pull_id", using: :btree
  end

  create_table "google_analytics_id_records", force: :cascade do |t|
    t.integer "pull_id",             null: false
    t.string  "google_analytics_id", null: false
    t.index ["pull_id"], name: "index_google_analytics_id_records_on_pull_id", using: :btree
  end

  create_table "pulls", force: :cascade do |t|
    t.integer  "website_id",                null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "url"
    t.boolean  "page",       default: true
    t.boolean  "domain",     default: true
    t.index ["website_id"], name: "index_pulls_on_website_id", using: :btree
  end

  create_table "referrals", force: :cascade do |t|
    t.integer "similar_web_id", null: false
    t.integer "kind",           null: false
    t.string  "url",            null: false
    t.float   "value",          null: false
    t.float   "delta",          null: false
    t.index ["similar_web_id"], name: "index_referrals_on_similar_web_id", using: :btree
  end

  create_table "similar_webs", force: :cascade do |t|
    t.integer  "pull_id",                          null: false
    t.string   "category"
    t.boolean  "is_verified"
    t.string   "icon_url"
    t.string   "redirect_url"
    t.float    "bounce_rate"
    t.float    "page_views"
    t.integer  "time_on_site_seconds"
    t.string   "total_last_month_visits"
    t.float    "total_relative_delta"
    t.integer  "last_engagement_year"
    t.integer  "last_engagement_month"
    t.float    "traffic_from_search"
    t.float    "traffic_from_social"
    t.float    "traffic_from_mail"
    t.float    "traffic_from_paid_referrals"
    t.float    "traffic_from_direct"
    t.float    "traffic_from_referrals"
    t.float    "traffic_from_app_store_internals"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["pull_id"], name: "index_similar_webs_on_pull_id", using: :btree
  end

  create_table "stored_pull_errors", force: :cascade do |t|
    t.integer  "pull_id",    null: false
    t.string   "location"
    t.text     "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pull_id"], name: "index_stored_pull_errors_on_pull_id", using: :btree
  end

  create_table "top_country_shares", force: :cascade do |t|
    t.integer "similar_web_id",  null: false
    t.integer "country_number",  null: false
    t.float   "percent_traffic", null: false
    t.index ["country_number"], name: "index_top_country_shares_on_country_number", using: :btree
    t.index ["similar_web_id"], name: "index_top_country_shares_on_similar_web_id", using: :btree
  end

  create_table "web_archive_records", force: :cascade do |t|
    t.integer  "pull_id", null: false
    t.string   "url",     null: false
    t.datetime "date"
    t.index ["pull_id"], name: "index_web_archive_records_on_pull_id", using: :btree
  end

  create_table "websites", force: :cascade do |t|
    t.string  "url",                        null: false
    t.integer "pull_count", default: 0,     null: false
    t.boolean "overt",      default: false, null: false
  end

  create_table "weekly_traffic_numbers", force: :cascade do |t|
    t.integer "similar_web_id", null: false
    t.integer "value",          null: false
    t.date    "week_of",        null: false
    t.index ["similar_web_id"], name: "index_weekly_traffic_numbers_on_similar_web_id", using: :btree
  end

  create_table "whois_records", force: :cascade do |t|
    t.integer "pull_id",         null: false
    t.string  "registrant_name", null: false
    t.index ["pull_id"], name: "index_whois_records_on_pull_id", using: :btree
  end

end
