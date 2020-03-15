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

ActiveRecord::Schema.define(version: 2020_03_15_124150) do

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
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "benefits", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "measurement_statement"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "experiment_benefits", id: false, force: :cascade do |t|
    t.bigint "benefit_id"
    t.bigint "experiment_id"
    t.index ["benefit_id"], name: "index_experiment_benefits_on_benefit_id"
    t.index ["experiment_id"], name: "index_experiment_benefits_on_experiment_id"
  end

  create_table "experiment_user_measurements", force: :cascade do |t|
    t.bigint "experiment_user_id"
    t.bigint "benefit_id"
    t.integer "starting_score"
    t.integer "ending_score"
    t.index ["benefit_id"], name: "index_experiment_user_measurements_on_benefit_id"
    t.index ["experiment_user_id"], name: "index_experiment_user_measurements_on_experiment_user_id"
  end

  create_table "experiment_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "experiment_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "starting_date", null: false
    t.datetime "ending_date", null: false
    t.integer "cancellation_reason"
    t.integer "difficulty"
    t.integer "experiment_continuation"
    t.index ["experiment_id"], name: "index_experiment_users_on_experiment_id"
    t.index ["user_id", "experiment_id"], name: "index_experiment_users_on_user_id_and_experiment_id", unique: true
    t.index ["user_id"], name: "index_experiment_users_on_user_id"
  end

  create_table "experiments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.string "slug"
    t.text "objective"
    t.index ["category_id"], name: "index_experiments_on_category_id"
    t.index ["slug"], name: "index_experiments_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.datetime "date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "experiment_id"
    t.boolean "experiment_success"
    t.index ["experiment_id"], name: "index_journal_entries_on_experiment_id"
    t.index ["slug"], name: "index_journal_entries_on_slug"
    t.index ["user_id"], name: "index_journal_entries_on_user_id"
  end

  create_table "journal_ratings", force: :cascade do |t|
    t.bigint "journal_entry_id", null: false
    t.bigint "journal_statement_id", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_entry_id"], name: "index_journal_ratings_on_journal_entry_id"
    t.index ["journal_statement_id"], name: "index_journal_ratings_on_journal_statement_id"
  end

  create_table "journal_statements", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "experiment_id"
    t.index ["experiment_id"], name: "index_resources_on_experiment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "experiment_user_measurements", "benefits"
  add_foreign_key "experiment_user_measurements", "experiment_users"
  add_foreign_key "experiment_users", "experiments"
  add_foreign_key "experiment_users", "users"
  add_foreign_key "experiments", "categories"
  add_foreign_key "journal_entries", "experiments"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "journal_ratings", "journal_entries"
  add_foreign_key "journal_ratings", "journal_statements"
  add_foreign_key "resources", "experiments"
end
