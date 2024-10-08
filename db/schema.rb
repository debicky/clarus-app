# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_427_170_838) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'orders', force: :cascade do |t|
    t.bigint 'warehouse_id', null: false
    t.bigint 'product_id', null: false
    t.bigint 'stock_id', null: false
    t.string 'status', default: 'new', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_orders_on_product_id'
    t.index ['stock_id'], name: 'index_orders_on_stock_id'
    t.index ['warehouse_id'], name: 'index_orders_on_warehouse_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'code'
    t.string 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'stock_balances', force: :cascade do |t|
    t.bigint 'warehouse_id', null: false
    t.bigint 'product_id', null: false
    t.bigint 'stock_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_stock_balances_on_product_id'
    t.index ['stock_id'], name: 'index_stock_balances_on_stock_id'
    t.index ['warehouse_id'], name: 'index_stock_balances_on_warehouse_id'
  end

  create_table 'stocks', force: :cascade do |t|
    t.integer 'quantity'
    t.bigint 'warehouse_id', null: false
    t.bigint 'product_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_stocks_on_product_id'
    t.index ['warehouse_id'], name: 'index_stocks_on_warehouse_id'
  end

  create_table 'warehouses', force: :cascade do |t|
    t.string 'code'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'orders', 'products'
  add_foreign_key 'orders', 'stocks'
  add_foreign_key 'orders', 'warehouses'
  add_foreign_key 'stock_balances', 'products'
  add_foreign_key 'stock_balances', 'stocks'
  add_foreign_key 'stock_balances', 'warehouses'
  add_foreign_key 'stocks', 'products'
  add_foreign_key 'stocks', 'warehouses'
end
