# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Stocks API' do
  path '/stocks' do
    get 'Retrieve all stocks' do
      tags 'Stocks'
      produces 'application/json'

      response '200', 'Stocks retrieved' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   warehouse_id: { type: :integer },
                   product_id: { type: :integer },
                   quantity: { type: :integer },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 }
               }

        run_test!
      end
    end

    post 'Create a new stock' do
      tags 'Stocks'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :warehouse_id, in: :query, type: :integer
      parameter name: :product_id, in: :query, type: :integer
      parameter name: :quantity, in: :query, type: :integer

      response '201', 'Stock created successfully' do
        let(:warehouse) { create(:warehouse) }
        let(:product) { create(:product) }
        let(:warehouse_id) { warehouse.id }
        let(:product_id) { product.id }
        let(:quantity) { 10 }

        run_test!
      end

      response '422', 'Invalid warehouse or product ID' do
        let(:warehouse_id) { -1 }
        let(:product_id) { -1 }
        let(:quantity) { 10 }

        run_test!
      end
    end
  end

  path '/stocks/{id}' do
    get 'Retrieve a stock' do
      tags 'Stocks'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Stock retrieved' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 warehouse_id: { type: :integer },
                 product_id: { type: :integer },
                 quantity: { type: :integer },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               }

        let(:stock) { create(:stock) }
        let(:id) { stock.id }

        run_test!
      end

      response '404', 'Stock not found' do
        let(:id) { -1 }

        run_test!
      end
    end
  end
end
