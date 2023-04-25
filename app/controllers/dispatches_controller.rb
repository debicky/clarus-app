# frozen_string_literal: true

class DispatchesController < ApplicationController
  before_action :set_order

  def create
    if @order.status == 'new'
      dispatch_order!
    elsif @order.status == 'dispatched'
      render json: { errors: 'Cannot dispatch an already dispatched order.' }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def dispatch_order!
    Order.transaction do
      @order.update!(status: 'dispatched')
      update_stock_quantity!
      render json: { message: 'Order dispatched and stock removed from the system.' }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid
    render json: { errors: 'Error dispatching the order.' }, status: :unprocessable_entity
  end

  def update_stock_quantity!
    @order.stock.update!(quantity: (@order.stock.quantity - 1).to_i)
  end
end
