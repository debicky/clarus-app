# frozen_string_literal: true

# app/controllers/stocks_controller.rb
class StocksController < ApplicationController
  before_action :set_stock, only: %i[show update destroy]
  before_action :find_warehouse, only: [:create]
  before_action :find_product, only: [:create]

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
    return invalid_warehouse_or_product if @warehouse.nil? || @product.nil?

    stock = Stock.new(warehouse: @warehouse, product: @product, quantity: stock_params[:quantity])

    if stock.valid? && StockCreator.new(stock: stock).call
      render json: { message: 'Stock created successfully.' }, status: :created
    else
      render json: { errors: 'Error creating the stock.' }, status: :unprocessable_entity
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.permit(:quantity, :warehouse_id, :product_id)
  end

  def find_warehouse
    @warehouse = Warehouse.find_by(id: params[:warehouse_id])
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end

  def invalid_warehouse_or_product
    render json: { errors: 'Invalid warehouse or product ID.' }, status: :unprocessable_entity
  end
end
