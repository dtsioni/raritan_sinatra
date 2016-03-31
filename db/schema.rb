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

ActiveRecord::Schema.define(version: 20160331202120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aliases", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "professor_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "professors", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "professor_id"
    t.integer  "user_id"
    t.decimal  "fairness"
    t.decimal  "clarity"
    t.decimal  "helpfulness"
    t.decimal  "preparation"
    t.decimal  "homework"
    t.decimal  "participation"
    t.decimal  "interesting"
    t.decimal  "attendance"
  end

end
