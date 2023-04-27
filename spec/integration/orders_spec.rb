# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Orders API' do
  path '/orders' do
    post 'Create Order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :integer },
          warehouse_id: { type: :integer }
        },
        required: %w[product_id warehouse_id]
      }

      response '201', 'Order created' do
        let(:product) { create(:product) }
        let(:warehouse) { create(:warehouse) }
        let!(:stock) { create(:stock, product: product, warehouse: warehouse, quantity: 10) }
        let(:order) { { product_id: product.id, warehouse_id: warehouse.id } }
        run_test!
      end

      response '404', 'Product or Warehouse not found' do
        let(:order) { { product_id: -1, warehouse_id: -1 } }
        run_test!
      end

      response '422', 'No stock available for the selected product and warehouse' do
        let(:product) { create(:product) }
        let(:warehouse) { create(:warehouse) }
        let!(:stock) { create(:stock, product: product, warehouse: warehouse, quantity: 0) }
        let(:order) { { product_id: product.id, warehouse_id: warehouse.id } }
        run_test!
      end
    end
  end
end
