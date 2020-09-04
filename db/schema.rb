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

ActiveRecord::Schema.define(version: 2020_09_03_030015) do

  create_table "containers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "position", default: "Fridge", null: false
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_containers_on_user_id"
  end

  create_table "deadline_alerts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "container_id"
    t.bigint "product_id"
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id"], name: "index_deadline_alerts_on_container_id"
    t.index ["product_id"], name: "index_deadline_alerts_on_product_id"
    t.index ["user_id"], name: "index_deadline_alerts_on_user_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "number", default: 1, null: false
    t.date "product_created_at", null: false
    t.date "product_expired_at", null: false
    t.text "description"
    t.bigint "user_id"
    t.bigint "container_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id"], name: "index_products_on_container_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "containers", "users"
  add_foreign_key "deadline_alerts", "containers"
  add_foreign_key "deadline_alerts", "products"
  add_foreign_key "deadline_alerts", "users"
  add_foreign_key "products", "containers"
  add_foreign_key "products", "users"
end
