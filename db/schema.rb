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

ActiveRecord::Schema.define(version: 20151225033151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "mobile"
    t.string   "address"
    t.text     "url"
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "deliveries", force: :cascade do |t|
    t.integer  "resume_id"
    t.integer  "job_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "state"
    t.datetime "read_at"
    t.integer  "final_payment_id"
    t.string   "message"
    t.datetime "deleted_at"
  end

  add_index "deliveries", ["resume_id", "job_id"], name: "index_deliveries_on_resume_id_and_job_id", unique: true, using: :btree

  create_table "interviews", force: :cascade do |t|
    t.text     "description"
    t.text     "content"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "avatar"
    t.string   "professor_name"
    t.string   "professor_title"
    t.text     "professor_brief"
    t.text     "brief"
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.integer  "bonus"
    t.integer  "deposit"
    t.string   "state"
    t.integer  "salary_min",  default: 0
    t.integer  "salary_max",  default: 0
    t.datetime "deleted_at"
    t.integer  "priority"
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "money_transfers", force: :cascade do |t|
    t.string   "type"
    t.integer  "amount"
    t.integer  "wallet_id"
    t.string   "state"
    t.string   "zhifubao_account"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "mobile"
    t.integer  "job_id"
    t.datetime "deleted_at"
  end

  add_index "money_transfers", ["wallet_id"], name: "index_money_transfers_on_wallet_id", using: :btree

  create_table "refund_requests", force: :cascade do |t|
    t.integer  "job_id"
    t.text     "reason"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "refund_requests", ["job_id"], name: "index_refund_requests_on_job_id", using: :btree

  create_table "rejections", force: :cascade do |t|
    t.integer  "delivery_id"
    t.string   "reason"
    t.text     "other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "rejections", ["delivery_id"], name: "index_rejections_on_delivery_id", using: :btree

  create_table "resumes", force: :cascade do |t|
    t.string   "candidate_name"
    t.text     "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile"
    t.string   "email"
    t.text     "description"
    t.integer  "supplier_id"
    t.boolean  "auto_delivery"
    t.boolean  "available"
    t.text     "pdf_attachment"
    t.datetime "deleted_at"
    t.text     "problem"
    t.text     "remark"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "mobile"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wallets", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "money",      default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id", using: :btree

  create_table "watchings", force: :cascade do |t|
    t.integer  "supplier_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "watchings", ["job_id"], name: "index_watchings_on_job_id", using: :btree
  add_index "watchings", ["supplier_id"], name: "index_watchings_on_supplier_id", using: :btree

  create_table "weixins", force: :cascade do |t|
    t.string   "user_name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weixins", ["user_id"], name: "index_weixins_on_user_id", using: :btree

end
