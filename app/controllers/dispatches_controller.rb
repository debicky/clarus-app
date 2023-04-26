# frozen_string_literal: true

class DispatchesController < ApplicationController
  def create
    order = find_order

    if order.status == 'dispatched'
      render json: { errors: 'Cannot dispatch an already dispatched order.' }, status: :unprocessable_entity
      return
    end

    dispatch_order!(order)
  end

  private

  def find_order
    Order.find(params[:order_id])
  end

  def dispatch_order!(order)
    ActiveRecord::Base.transaction do
      order.update!(status: 'dispatched')
      update_stock_quantity!(order)
      render json: { message: 'Order dispatched and stock removed from the system.' }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid
    render json: { errors: 'Error dispatching the order.' }, status: :unprocessable_entity
  end

  def update_stock_quantity!(order)
    order.stock.update!(quantity: order.stock.quantity - 1)
  end
end
