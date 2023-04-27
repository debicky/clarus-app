# frozen_string_literal: true

class StockBalance < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  belongs_to :stock

  def available_stocks
    stock.quantity
  end

  def ordered_stocks
    stock.orders.only_dispatched.count
  end
end
