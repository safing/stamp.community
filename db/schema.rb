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

ActiveRecord::Schema.define(version: 2019_02_26_102653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.bigint "owner_id"
    t.string "owner_type"
    t.jsonb "parameters", default: {}, null: false
    t.bigint "recipient_id"
    t.string "recipient_type"
    t.bigint "trackable_id"
    t.string "trackable_type"
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_api_keys_on_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "apps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "link", null: false
    t.string "name", null: false
    t.jsonb "os"
    t.datetime "updated_at", null: false
    t.text "uuid", default: -> { "gen_random_uuid()" }, null: false
  end

  create_table "boosts", force: :cascade do |t|
    t.bigint "cause_id", null: false
    t.datetime "created_at", null: false
    t.bigint "reputation", null: false
    t.bigint "trigger_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["cause_id"], name: "index_boosts_on_cause_id"
    t.index ["trigger_id"], name: "index_boosts_on_trigger_id"
    t.index ["user_id"], name: "index_boosts_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "commentable_id", null: false
    t.string "commentable_type", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "domains", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "parent_id"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_domains_on_name", unique: true
    t.index ["parent_id"], name: "index_domains_on_parent_id"
  end

  create_table "labels", force: :cascade do |t|
    t.jsonb "config", default: {}, null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.bigint "licence_id", null: false
    t.string "name", null: false
    t.bigint "parent_id"
    t.datetime "updated_at", null: false
    t.index ["licence_id"], name: "index_labels_on_licence_id"
    t.index ["parent_id"], name: "index_labels_on_parent_id"
  end

  create_table "licences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.text "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "actor_id", null: false
    t.jsonb "cache", default: {}, null: false
    t.datetime "created_at", null: false
    t.boolean "read", default: false, null: false
    t.bigint "recipient_id", null: false
    t.bigint "reference_id", null: false
    t.string "reference_type", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_notifications_on_activity_id"
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
    t.index ["reference_type", "reference_id"], name: "index_notifications_on_reference_type_and_reference_id"
  end

  create_table "stamps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}, null: false
    t.bigint "stampable_id", null: false
    t.string "stampable_type", null: false
    t.text "state", null: false
    t.string "type", default: "Stamp::Label", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["stampable_type", "stampable_id"], name: "index_stamps_on_stampable_type_and_stampable_id"
    t.index ["user_id"], name: "index_stamps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.integer "reputation", default: 0, null: false
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "user", null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.boolean "accept", null: false
    t.datetime "created_at", null: false
    t.integer "power", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "votable_id", null: false
    t.string "votable_type", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_id", "votable_type", "user_id"], name: "index_votes_on_votable_id_and_votable_type_and_user_id", unique: true
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "boosts", "activities", column: "cause_id"
  add_foreign_key "boosts", "activities", column: "trigger_id"
  add_foreign_key "boosts", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "domains", "domains", column: "parent_id"
  add_foreign_key "labels", "labels", column: "parent_id"
  add_foreign_key "notifications", "activities"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "stamps", "users"
  add_foreign_key "votes", "users"
end
