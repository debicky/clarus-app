# frozen_string_literal: true

class StockBalance < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  belongs_to :order

  def available_stocks
    Stock.with_product_and_warehouse(product, warehouse).sum(:quantity)
  end

  def ordered_stocks
    Order.joins(:stock).where(stocks: { warehouse: warehouse, product: product }).only_dispatched.count
  end
end
