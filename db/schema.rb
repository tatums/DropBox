# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101020012616) do

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "remote_ip"
    t.string   "action_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "customer_number"
    t.string   "first"
    t.string   "last"
    t.string   "first_order_number"
    t.string   "card_type"
    t.string   "credit_card"
    t.date     "expected_ship_date"
    t.string   "exp_month"
    t.string   "exp_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed",          :default => false
    t.string   "processed_by_name"
    t.integer  "processed_by"
    t.datetime "processed_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "username"
    t.string   "email"
    t.boolean  "is_administrator"
    t.boolean  "is_active"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
