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

ActiveRecord::Schema.define(version: 20240609151044) do

  create_table "approvals", force: :cascade do |t|
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "schedule"
    t.boolean "tomorrow_check"
    t.datetime "overtime_check"
    t.string "confirmation"
    t.boolean "attendance_change_check"
    t.boolean "attendance_change_flag"
    t.integer "month"
    t.integer "superior_id"
    t.integer "superior_month_notice_confirmation"
    t.integer "confirmation_status", default: 0
    t.boolean "check_box", default: false
    t.date "month_first_day"
    t.string "month_request_status", default: "なし"
    t.integer "month_request_superior_id"
    t.index ["month_first_day", "user_id"], name: "index_attendances_on_month_first_day_and_user_id", unique: true
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "work_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "work_time", default: "2024-05-18 22:30:00"
    t.string "employee_number"
    t.string "uid"
    t.boolean "superior"
    t.string "affiliation"
    t.time "basic_work_time", default: "2000-01-01 23:00:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
