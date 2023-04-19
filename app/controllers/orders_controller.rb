# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    product = find_product
    warehouse = find_warehouse

    ActiveRecord::Base.transaction do
      stock = find_stock(product, warehouse)

      unless stock
        render json: { error: 'No stock available for the selected product and warehouse' },
               status: :unprocessable_entity
        return
      end

      process_order(warehouse, product, stock)
    end
  end

  private

  def find_product
    Product.find(params[:product_id])
  end

  def find_warehouse
    Warehouse.find(params[:warehouse_id])
  end

  def find_stock(product, warehouse)
    Stock.where(product: product, warehouse: warehouse).where('quantity > 0').lock(true).first
  end

  def create_order(warehouse, product, stock)
    Order.new(warehouse: warehouse, product: product, stock: stock, status: 'new')
  end

  def update_stock(stock)
    stock.update!(quantity: stock.quantity - 1)
  end

  def process_order(warehouse, product, stock)
    order = create_order(warehouse, product, stock)
    if order.save!
      update_stock(stock)
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end
end
