# app/controllers/stocks_controller.rb
class StocksController < ApplicationController
  before_action :set_stock, only: %i[show update destroy]
  before_action :set_warehouse, only: [:create]
  before_action :set_product, only: [:create]

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
    stock = Stock.new(warehouse: @warehouse, product: @product, quantity: stock_params[:quantity])

    if stock.quantity.positive? && create_stock(stock)
      render json: { message: 'Stock created successfully.' }, status: :created
    else
      render json: { errors: 'Error creating the stock.' }, status: :unprocessable_entity
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

  def set_warehouse
    @warehouse = Warehouse.find(params[:warehouse_id])
  end

  def set_product
    @product = Product.find(params[:product_id])
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
