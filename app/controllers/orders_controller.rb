# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    warehouse = Warehouse.find(params[:warehouse_id])

    ActiveRecord::Base.transaction do
      stock = Stock.where(product: product, warehouse: warehouse).where('quantity > 0').lock(true).first
      if stock.present?
        order = Order.new(warehouse: warehouse, product: product, stock: stock, status: 'new')
        if order.save!
          stock.update!(quantity: stock.quantity - 1)
          render json: order, status: :created
        else
          render json: order.errors, status: :unprocessable_entity and return
        end
      else
        render json: { error: 'No stock available for the selected product and warehouse' },
               status: :unprocessable_entity and return
      end
    end
  end
end
