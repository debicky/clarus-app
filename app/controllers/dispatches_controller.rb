# frozen_string_literal: true

class DispatchesController < ApplicationController
  before_action :find_order, only: :create
  def create
    return order_dispatched if @order.dispatched?

    dispatch_order(@order)
  end

  private

  def find_order
    @order = Order.find(params[:order_id])
  end

  def order_dispatched
    render json: { errors: 'Cannot dispatch an already dispatched order.' }, status: :unprocessable_entity
  end

  def dispatch_order(order)
    OrderDispatcher.new(order: order).call

    render json: { message: 'Order dispatched and stock removed from the system.' }, status: :ok
  rescue ActiveRecord::RecordInvalid
    render json: order.errors, status: :unprocessable_entity
  end
end
