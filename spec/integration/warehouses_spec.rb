# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Warehouses API' do
  path '/warehouses' do
    get 'Retrieve all warehouses' do
      tags 'Warehouses'
      produces 'application/json'

      response '200', 'Warehouses retrieved' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   code: { type: :string },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 }
               }

        run_test!
      end
    end

    post 'Create a new warehouse' do
      tags 'Warehouses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :warehouse, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :string }
        },
        required: ['code']
      }

      response '201', 'Warehouse created successfully' do
        let(:warehouse) { { code: 'code123' } }

        run_test!
      end

      response '422', 'Invalid request parameters' do
        let(:warehouse) { { code: '' } }

        run_test!
      end
    end
  end

  path '/warehouses/{id}' do
    get 'Retrieve a warehouse' do
      tags 'Warehouses'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Warehouse retrieved' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 code: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               }

        let(:warehouse) { create(:warehouse) }
        let(:id) { warehouse.id }

        run_test!
      end

      response '404', 'Warehouse not found' do
        let(:id) { -1 }

        run_test!
      end
    end

    put 'Update warehouse details' do
      tags 'Warehouses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :warehouse, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :string }
        },
        required: ['code']
      }

      response '200', 'Warehouse details updated' do
        let(:warehouse) { create(:warehouse) }
        let(:id) { warehouse.id }
        let(:updated_warehouse) { { code: 'code124' } }

        run_test!
      end
    end

    delete 'Delete a warehouse' do
      tags 'Warehouses'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '204', 'Warehouse deleted' do
        let(:warehouse) { create(:warehouse) }
        let(:id) { warehouse.id }

        run_test!
      end

      response '404', 'Warehouse not found' do
        let(:id) { -1 }

        run_test!
      end
    end
  end
end
