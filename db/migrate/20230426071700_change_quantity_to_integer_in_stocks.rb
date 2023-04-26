class ChangeQuantityToIntegerInStocks < ActiveRecord::Migration[7.0]
  def change
    change_column :stocks, :quantity, :integer
  end
end
