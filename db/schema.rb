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

ActiveRecord::Schema.define(version: 20150424121943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", force: true do |t|
    t.integer  "follower_id"
    t.integer  "leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "user_id"
    t.string   "friend_email"
    t.string   "friend_name"
    t.string   "token"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", force: true do |t|
    t.integer "user_id"
    t.integer "video_id"
    t.integer "priority"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string  "username"
    t.string  "email"
    t.string  "password_digest"
    t.string  "token"
    t.boolean "admin"
    t.string  "stripe_customer_id"
    t.boolean "locked"
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "small_cover_url"
    t.string   "large_cover_url"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "small_cover_upload"
    t.string   "large_cover_upload"
    t.string   "url"
  end

end
