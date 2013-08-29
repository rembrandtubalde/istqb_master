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

ActiveRecord::Schema.define(version: 20130825100517) do

  create_table "attempts", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer"
    t.integer  "correct_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attempts", ["user_id", "created_at"], name: "index_attempts_on_user_id_and_created_at", using: :btree

  create_table "questions", force: true do |t|
    t.text     "question"
    t.text     "option_one"
    t.text     "option_two"
    t.text     "option_three"
    t.text     "option_four"
    t.integer  "correct_answer"
    t.string   "certificate_type", default: "CTFL"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["id"], name: "index_questions_on_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "is_superuser",     default: false
    t.string   "certificate_type", default: "CTFL"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
