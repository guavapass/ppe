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

ActiveRecord::Schema.define(version: 20161018070158) do

  create_table "billing_adjustments", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_billing_adjustments_on_booking_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "lesson_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_bookings_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.datetime "starts_at"
    t.integer  "duration_in_minutes"
    t.string   "description"
    t.string   "studio_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "no_show_charges", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_no_show_charges_on_booking_id"
  end

end
