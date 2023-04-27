# frozen_string_literal: true

class CreateStockBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_balances do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
