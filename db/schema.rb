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

ActiveRecord::Schema.define(:version => 15) do

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
  end

  create_table "interactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "int_type",   :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "like_type"
    t.integer  "type_id"
    t.boolean  "like"
    t.boolean  "dontlike"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "note_type"
    t.integer  "from_id"
    t.integer  "post_id"
    t.boolean  "unread",     :default => true, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",    :default => 1
    t.string   "title",      :default => ""
    t.string   "post_type"
    t.text     "content"
    t.datetime "created_at"
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "posts_tags", ["post_id", "tag_id"], :name => "index_posts_tags_on_post_id_and_tag_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shares", :force => true do |t|
    t.string   "user_id"
    t.string   "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => 25
    t.datetime "updated_at"
  end

  create_table "tags_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  add_index "tags_users", ["user_id", "tag_id"], :name => "index_tags_users_on_user_id_and_tag_id"

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "profile",                                :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "email"
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "name",                :default => "",    :null => false
    t.string   "bio"
    t.string   "url"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "active",              :default => false, :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

end
