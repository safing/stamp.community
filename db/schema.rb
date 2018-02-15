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

ActiveRecord::Schema.define(version: 20171113154430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_stamps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.binary "data"
    t.integer "downvote_count"
    t.bigint "stampable_id"
    t.string "stampable_type"
    t.text "state"
    t.datetime "updated_at", null: false
    t.integer "upvote_count"
    t.index ["creator_id"], name: "index_data_stamps_on_creator_id"
    t.index ["stampable_type", "stampable_id"], name: "index_data_stamps_on_stampable_type_and_stampable_id"
  end

  create_table "domains", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.string "name"
    t.bigint "parent_id"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_domains_on_creator_id"
    t.index ["parent_id"], name: "index_domains_on_parent_id"
  end

  create_table "labels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "parent_id"
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_labels_on_parent_id"
  end

  create_table "stamps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.integer "downvote_count"
    t.bigint "label_id"
    t.integer "percentage"
    t.bigint "stampable_id"
    t.string "stampable_type"
    t.text "state"
    t.datetime "updated_at", null: false
    t.integer "upvote_count"
    t.index ["creator_id"], name: "index_stamps_on_creator_id"
    t.index ["label_id"], name: "index_stamps_on_label_id"
    t.index ["stampable_type", "stampable_id"], name: "index_stamps_on_stampable_type_and_stampable_id"
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
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
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
    t.datetime "created_at", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "votable_id", null: false
    t.string "votable_type", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
  end

  add_foreign_key "data_stamps", "users", column: "creator_id"
  add_foreign_key "domains", "domains", column: "parent_id"
  add_foreign_key "domains", "users", column: "creator_id"
  add_foreign_key "labels", "labels", column: "parent_id"
  add_foreign_key "stamps", "labels"
  add_foreign_key "stamps", "users", column: "creator_id"
  add_foreign_key "votes", "users"
end
