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

ActiveRecord::Schema.define(version: 20140315211720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contents", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: true do |t|
    t.string   "url"
    t.integer  "site_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "params", force: true do |t|
    t.string   "outgrader_ip",     default: "127.0.0.1"
    t.string   "outgrader_port",   default: "8080"
    t.string   "outgrader_status", default: "stopped"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "redirector_ip",    default: "10.74.0.28"
    t.string   "redirector_port",  default: "80"
  end

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "css"
    t.text     "banner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spnuke_files", force: true do |t|
    t.integer  "files_id"
    t.integer  "files_cat_id"
    t.string   "files_title"
    t.text     "files_url"
    t.text     "files_description"
    t.datetime "files_date"
    t.decimal  "files_size"
    t.string   "files_server"
    t.integer  "files_id_serial"
    t.integer  "year"
    t.string   "quality"
    t.string   "remote_url"
    t.string   "remote_name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_files", force: true do |t|
    t.string   "internal_name"
    t.text     "internal_url"
    t.string   "external_name"
    t.text     "external_url"
    t.string   "quality"
    t.integer  "year"
    t.integer  "size"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits", force: true do |t|
    t.integer  "link_id"
    t.datetime "time"
    t.string   "remote_ip"
    t.boolean  "is_click",  default: false
    t.string   "url"
    t.string   "film"
  end

end
