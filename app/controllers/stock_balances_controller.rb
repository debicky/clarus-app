# frozen_string_literal: true

class StockBalancesController < ApplicationController
  before_action :find_stock_balance, only: :show

  def show
    render json: stock_balance_data
  end

  private

  def find_stock_balance
    @stock_balance = StockBalance.find_by_id(params[:id])
    render json: { error: 'Stock not found' }, status: :not_found unless @stock_balance
  end

  def stock_balance_data
    {
      stock_balance: {
        warehouse: {
          id: @stock_balance.warehouse.id,
          code: @stock_balance.warehouse.code
        },
        product: {
          id: @stock_balance.product.id,
          code: @stock_balance.product.code,
          description: @stock_balance.product.description
        },
        available_stocks: @stock_balance.available_stocks,
        ordered_stocks: @stock_balance.ordered_stocks
      }
    }
  end
end
