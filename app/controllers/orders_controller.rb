# frozen_string_literal: true

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :find_product, only: :create
  before_action :find_warehouse, only: :create
  before_action :find_stock, only: :create

  def create
    return no_stock_available unless @stock

    create_order(@stock)
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_warehouse
    @warehouse = Warehouse.find(params[:warehouse_id])
  end

  def find_stock
    @stock = Stock.with_product_and_warehouse(@product, @warehouse).with_positive_quantity.lock(true).first
  end

  def create_order(stock)
    order = OrderCreator.new(
      warehouse: @warehouse,
      product: @product,
      stock: stock
    ).call

    render json: order, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render_error(e.message, :not_found)
  rescue ActiveRecord::RecordInvalid => e
    render_error(e.message, :unprocessable_entity)
  end

  def no_stock_available
    render json: { error: 'No stock available for the selected product and warehouse' },
           status: :unprocessable_entity
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
