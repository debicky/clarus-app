# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Stock Balances API' do
  path '/stock_balances/{id}' do
    get 'Get Stock Balance details' do
      tags 'Stock Balances'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      let(:product) { create(:product) }
      let(:warehouse) { create(:warehouse) }
      let!(:stock) { create(:stock) }
      let!(:dispatched_order) { create(:order, :dispatched, stock: stock) }
      let!(:stock_balance) do
        create(:stock_balance, product: product, warehouse: warehouse, stock: stock)
      end
      let(:id) { stock_balance.id }

      response '200', 'Stock Balance details found' do
        schema type: :object,
               properties: {
                 stock_balance: {
                   type: :object,
                   properties: {
                     warehouse: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         code: { type: :string }
                       },
                       required: %w[id code]
                     },
                     product: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         code: { type: :string },
                         description: { type: :string }
                       },
                       required: %w[id code description]
                     },
                     available_stocks: { type: :integer },
                     ordered_stocks: { type: :integer }
                   },
                   required: %w[warehouse product available_stocks ordered_stocks]
                 }
               },
               required: ['stock_balance']

        run_test!
      end

      response '404', 'Stock Balance not found' do
        let(:id) { -1 }
        run_test!
      end
    end
  end
end
