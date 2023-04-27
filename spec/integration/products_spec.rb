# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Products API' do
  path '/products' do
    get 'List products' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Products listed' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   code: { type: :string },
                   description: { type: :string }
                 },
                 required: %w[id code description]
               }

        let!(:products) { create_list(:product, 3) }
        run_test!
      end
    end

    post 'Create a new product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :string },
          description: { type: :string }
        },
        required: %w[code description]
      }

      let(:product) { { code: 'P123', description: 'Test product' } }

      response '201', 'Product created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 code: { type: :string },
                 description: { type: :string }
               },
               required: %w[id code description]

        run_test!
      end

      response '422', 'Invalid request parameters' do
        let(:product) { { code: '', description: '' } }
        run_test!
      end
    end
  end

  path '/products/{id}' do
    get 'Get product details' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:product) { create(:product) }
      let(:id) { product.id }

      response '200', 'Product details found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 code: { type: :string },
                 description: { type: :string }
               },
               required: %w[id code description]

        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    put 'Update product details' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :string },
          description: { type: :string }
        },
        required: %w[code description]
      }

      let(:product) { create(:product) }
      let(:id) { product.id }
      let(:updated_product) { { code: 'P124', description: 'Updated test product' } }

      response '200', 'Product details updated' do
        let(:product_params) { updated_product }
        before do
          put "/products/#{id}", params: product_params.to_json, headers: { 'Content-Type': 'application/json' }
        end
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    delete 'Delete a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:product) { create(:product) }
      let(:id) { product.id }

      response '204', 'Product deleted' do
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { -1 }
        run_test!
      end
    end
  end
end
