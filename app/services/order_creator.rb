# frozen_string_literal: true

class OrderCreator
  def initialize(warehouse:, product:, stock:)
    @warehouse = warehouse
    @product = product
    @stock = stock
  end

  def call
    process_order(@warehouse, @product, @stock)
  end

  private

  def process_order(warehouse, product, stock)
    ActiveRecord::Base.transaction do
      order = create_order(warehouse, product, stock)

      update_stock!(stock) if order.save!

      order
    end
  end

  def create_order(warehouse, product, stock)
    Order.new(warehouse: warehouse, product: product, stock: stock)
    # before validation ustaw status new
    # stock.orders.new(warehouse: warehouse, product: product, status: 'new')
    # current_user zrobie nie ma opcji na jebniecie sie, zeby przekazac zly param albo czegos zapomne
  end

  def update_stock!(stock)
    stock.update!(quantity: stock.quantity - 1)
    # update_conters against race conditions?
  end
end
