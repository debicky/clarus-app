# frozen_string_literal: true

class OrderDispatcher
  def initialize(order:)
    @order = order
  end

  def call
    dispatch_order(@order)
  end

  private

  def dispatch_order(order)
    ActiveRecord::Base.transaction do
      locked_order = order.lock!
      locked_stock = locked_order.stock.lock!

      locked_order.update!(status: 'dispatched')
      update_stock_quantity(locked_stock)
    end
  end

  def update_stock_quantity(stock)
    stock.update!(quantity: stock.quantity - 1)
  end
end
