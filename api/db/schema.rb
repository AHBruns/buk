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

ActiveRecord::Schema.define(version: 2022_01_04_020438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.bigint "account_id"
    t.string "isbn", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_books_on_account_id"
  end

  create_table "cells", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "grid_id"
    t.index ["account_id"], name: "index_cells_on_account_id"
    t.index ["grid_id", "x", "y"], name: "index_cells_on_grid_id_and_x_and_y", unique: true
    t.index ["grid_id"], name: "index_cells_on_grid_id"
  end

  create_table "google_book_requests", force: :cascade do |t|
    t.string "isbn", null: false
    t.jsonb "response", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["isbn"], name: "index_google_book_requests_on_isbn", unique: true
  end

  create_table "grids", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id", "name"], name: "index_grids_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_grids_on_account_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "index", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cell_id"
    t.string "placeable_type"
    t.bigint "placeable_id"
    t.index ["account_id"], name: "index_items_on_account_id"
    t.index ["cell_id", "index"], name: "index_items_on_cell_id_and_index", unique: true
    t.index ["cell_id"], name: "index_items_on_cell_id"
    t.index ["placeable_type", "placeable_id"], name: "index_items_on_placeable_type_and_placeable_id", unique: true
  end

  add_foreign_key "books", "accounts"
  add_foreign_key "cells", "accounts"
  add_foreign_key "cells", "grids"
  add_foreign_key "grids", "accounts"
  add_foreign_key "items", "accounts"
  add_foreign_key "items", "cells"
end
