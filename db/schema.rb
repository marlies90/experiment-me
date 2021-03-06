# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_19_141608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "benefits", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "measurement_statement"
  end

  create_table "blog_comments", force: :cascade do |t|
    t.string "author_name", null: false
    t.string "email", null: false
    t.text "comment", null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_blog_comments_on_commentable_type_and_commentable_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "name", null: false
    t.text "summary", null: false
    t.text "description", null: false
    t.text "image"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "publish_date"
    t.text "meta_title"
    t.text "meta_description"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "blog_posts_experiments", id: false, force: :cascade do |t|
    t.bigint "blog_post_id", null: false
    t.bigint "experiment_id", null: false
    t.index ["blog_post_id"], name: "index_blog_posts_experiments_on_blog_post_id"
    t.index ["experiment_id"], name: "index_blog_posts_experiments_on_experiment_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "description_meta"
    t.text "title"
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
    t.integer "life_impact"
    t.text "ending_note"
    t.text "recommendation"
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
    t.text "description_meta"
    t.text "title"
    t.text "practical_details"
    t.text "implementation_intention"
    t.date "publish_date"
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

  create_table "images", force: :cascade do |t|
    t.string "name", null: false
    t.string "alt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mail_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "mail_type", null: false
    t.integer "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mail_preferences_on_user_id"
  end

  create_table "observations", force: :cascade do |t|
    t.datetime "date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "experiment_id"
    t.boolean "experiment_success"
    t.integer "mood"
    t.integer "sleep"
    t.integer "health"
    t.integer "relax"
    t.integer "connect"
    t.integer "meaning"
    t.text "note"
    t.index ["experiment_id"], name: "index_observations_on_experiment_id"
    t.index ["slug"], name: "index_observations_on_slug"
    t.index ["user_id"], name: "index_observations_on_user_id"
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
    t.string "time_zone", default: "UTC"
    t.boolean "terms_agreement", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "experiment_user_measurements", "benefits"
  add_foreign_key "experiment_user_measurements", "experiment_users"
  add_foreign_key "experiment_users", "experiments"
  add_foreign_key "experiment_users", "users"
  add_foreign_key "experiments", "categories"
  add_foreign_key "observations", "experiments"
  add_foreign_key "observations", "users"
  add_foreign_key "resources", "experiments"
end
