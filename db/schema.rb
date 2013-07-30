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

ActiveRecord::Schema.define(:version => 20130730231506) do

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id",    :precision => 38, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "tenant_id",  :precision => 38, :scale => 0
  end

  add_index "microposts", ["tenant_id"], :name => "index_microposts_on_tenant_id"
  add_index "microposts", ["user_id", "created_at"], :name => "i_mic_use_id_cre_at"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id", :precision => 38, :scale => 0
    t.integer  "followed_id", :precision => 38, :scale => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "tenant_id",   :precision => 38, :scale => 0
  end

  add_index "relationships", ["followed_id"], :name => "i_relationships_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "i_rel_fol_id_fol_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "i_relationships_follower_id"
  add_index "relationships", ["tenant_id"], :name => "i_relationships_tenant_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tenants", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tenants_users", :id => false, :force => true do |t|
    t.integer "tenant_id", :precision => 38, :scale => 0
    t.integer "user_id",   :precision => 38, :scale => 0
  end

  add_index "tenants_users", ["tenant_id"], :name => "i_tenants_users_tenant_id"
  add_index "tenants_users", ["user_id"], :name => "index_tenants_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.string   "remember_token"
    t.boolean  "admin",                                                 :default => false
    t.string   "encrypted_password",                                    :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], :name => "i_users_reset_password_token", :unique => true

end
