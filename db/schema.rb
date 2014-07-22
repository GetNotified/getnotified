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

ActiveRecord::Schema.define(version: 20140722054203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "conditions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "input_type"
    t.string   "html_control"
    t.boolean  "required"
    t.string   "values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notification_type_id"
  end

  add_index "conditions", ["notification_type_id"], name: "index_conditions_on_notification_type_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "notification_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "service_id"
    t.string   "account_required"
    t.integer  "condition_id"
    t.boolean  "featured"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_types", ["condition_id"], name: "index_notification_types_on_condition_id", using: :btree
  add_index "notification_types", ["service_id"], name: "index_notification_types_on_service_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "service_id"
    t.string   "notif_type"
    t.hstore   "conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["service_id"], name: "index_notifications_on_service_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_url"
    t.integer  "notification_type_id"
    t.string   "account_required"
    t.boolean  "featured"
    t.boolean  "public"
  end

  add_index "services", ["notification_type_id"], name: "index_services_on_notification_type_id", using: :btree

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

end
