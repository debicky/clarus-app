# frozen_string_literal: true

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def create
    product = find_product
    warehouse = find_warehouse

    if product.nil? || warehouse.nil?
      render json: { error: 'Invalid product or warehouse ID.' }, status: :unprocessable_entity
      return
    end

    stock = find_stock(product, warehouse)

    unless stock
      render json: { error: 'No stock available for the selected product and warehouse' },
             status: :unprocessable_entity
      return
    end

    order = process_order!(warehouse, product, stock)
    render json: order, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors, status: :unprocessable_entity
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

  def update_stock!(stock)
    stock.update!(quantity: stock.quantity - 1)
  end

  def process_order!(warehouse, product, stock)
    ActiveRecord::Base.transaction do
      order = create_order(warehouse, product, stock)

      update_stock!(stock) if order.save!

      order
    end
  end
end
