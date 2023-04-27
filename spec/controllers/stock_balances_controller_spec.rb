# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockBalancesController, type: :controller do
  let(:warehouse) { create(:warehouse) }
  let(:product) { create(:product) }
  let(:stock) { create(:stock) }
  let(:stock_balance) { create(:stock_balance, warehouse: warehouse, product: product) }
  let(:params) { { id: stock_balance.id } }

  subject(:get_show) { get :show, params: params }

  describe 'GET #show' do
    it 'returns a success response' do
      get_show
      expect(response).to be_successful
    end

    context 'with one order' do
      let!(:stock) { Stock.create!(warehouse: warehouse, product: product, quantity: 10) }
      let!(:order) do
        Order.create!(
          warehouse: warehouse,
          product: product,
          stock: stock,
          status: 'new'
        )
      end

      it 'returns the correct stock balance data' do
        get_show
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expected_data = {
          stock_balance: {
            warehouse: {
              id: warehouse.id,
              code: warehouse.code
            },
            product: {
              id: product.id,
              code: product.code,
              description: product.description
            },
            available_stocks: stock_balance.available_stocks,
            ordered_stocks: stock_balance.ordered_stocks
          }
        }

        expect(parsed_response).to eq(expected_data)
      end
    end

    context 'with multiple orders in different statuses' do
      let!(:stock) { Stock.create!(warehouse: warehouse, product: product, quantity: 20) }
      let!(:new_order) do
        Order.create!(
          warehouse: warehouse,
          product: product,
          stock: stock,
          status: 'new'
        )
      end
      let!(:dispatched_order) do
        Order.create!(
          warehouse: warehouse,
          product: product,
          stock: stock,
          status: 'dispatched'
        )
      end

      it 'returns the correct stock balance data' do
        get_show
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expected_data = {
          stock_balance: {
            warehouse: {
              id: warehouse.id,
              code: warehouse.code
            },
            product: {
              id: product.id,
              code: product.code,
              description: product.description
            },
            available_stocks: stock_balance.available_stocks,
            ordered_stocks: stock_balance.ordered_stocks
          }
        }

        expect(parsed_response).to eq(expected_data)
      end
    end

    context 'with multiple products in the same warehouse' do
      let(:product2) { create(:product) }
      let!(:stock1) { Stock.create!(warehouse: warehouse, product: product, quantity: 10) }
      let!(:stock2) { Stock.create!(warehouse: warehouse, product: product2, quantity: 15) }
      let!(:order1) do
        Order.create!(
          warehouse: warehouse,
          product: product,
          stock: stock1,
          status: 'new'
        )
      end
      let!(:order2) do
        Order.create!(
          warehouse: warehouse,
          product: product2,
          stock: stock2,
          status: 'new'
        )
      end

      it 'returns the correct stock balance data' do
        get_show
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expected_data = {
          stock_balance: {
            warehouse: {
              id: warehouse.id,
              code: warehouse.code
            },
            product: {
              id: product.id,
              code: product.code,
              description: product.description
            },
            available_stocks: stock_balance.available_stocks,
            ordered_stocks: stock_balance.ordered_stocks
          }
        }

        expect(parsed_response).to eq(expected_data)
      end
    end
  end
end
