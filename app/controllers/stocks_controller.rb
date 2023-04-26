# frozen_string_literal: true

# app/controllers/stocks_controller.rb
class StocksController < ApplicationController
  before_action :set_stock, only: %i[show update destroy]

  # GET /stocks
  def index
    @stocks = Stock.all

    render json: @stocks
  end

  # GET /stocks/1
  def show
    render json: @stock
  end

  # POST /stocks
  def create
    product = find_product
    warehouse = find_warehouse

    if warehouse.nil? || product.nil?
      render json: { errors: 'Invalid warehouse or product ID.' }, status: :unprocessable_entity
    else
      stock = Stock.new(warehouse: warehouse, product: product, quantity: stock_params[:quantity])

      if stock.quantity.positive? && create_stock(stock)
        render json: { message: 'Stock created successfully.' }, status: :created
      else
        render json: { errors: 'Error creating the stock.' }, status: :unprocessable_entity
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = Stock.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def stock_params
    params.permit(:quantity, :warehouse_id, :product_id)
  end

  def find_warehouse
    @warehouse = Warehouse.find_by(id: params[:warehouse_id])
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end

  def create_stock(stock)
    Stock.transaction do
      existing_stock = Stock.find_by(warehouse: stock.warehouse, product: stock.product)

      if existing_stock
        existing_stock.quantity += stock.quantity.to_i
        existing_stock.save!
      else
        stock.save!
      end
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
