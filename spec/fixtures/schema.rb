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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120318055757) do

  create_table "chapters", :force => true do |t|
    t.string "title"
    t.text "description"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "video_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "cuepoint_key"
  end

  create_table "users", :force => true do |t|
    t.string "email", :default => "", :null => false
    t.string "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.integer "user_id"
    t.integer  "company_id"
    t.string "title"
    t.text "description"
    t.string "tags"
    t.string "thumb"
    t.string "status", :limit => 15, :default => "draft"
    t.string "kaltura_token"
    t.integer "security_filter_type"
    t.string "security_filter_value"
    t.string "kaltura_key"
    t.datetime "kaltura_syncd_at"
    t.integer "hits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "duration"
    t.text "thumbnail_url"
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
    t.integer "parent_id"
    t.string 'kaltura_category_key'
  end

  create_table "categories_videos", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "video_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "partner_id"
    t.string   "category"
    t.string   "player_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "features_hash"
    t.string   "login"
    t.string   "password"
    t.string   "admin_secret"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
