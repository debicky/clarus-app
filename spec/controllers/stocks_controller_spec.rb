# frozen_string_literal: true

# spec/controllers/stocks_controller_spec.rb
require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  let!(:warehouse) { create(:warehouse) }
  let!(:product) { create(:product) }
  let!(:stock) { create(:stock, warehouse: warehouse, product: product, quantity: 5) }

  describe 'GET #index' do
    subject(:get_index) { get :index }

    it 'returns a success response' do
      get_index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all stocks' do
      get_index
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { id: stock.id } }

    it 'returns a success response' do
      get_show
      expect(response).to have_http_status(:ok)
    end

    it 'returns the requested stock' do
      get_show
      expect(JSON.parse(response.body)['id']).to eq(stock.id)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { warehouse_id: warehouse.id, product_id: product.id, quantity: 3 } }
    let(:invalid_params) { { warehouse_id: warehouse.id, product_id: product.id, quantity: -3 } }

    subject(:post_create) { post :create, params: params }

    context 'when stock creation is successful' do
      let(:params) { valid_params }

      it 'increases the stock quantity by 3' do
        expect { post_create }.to change { stock.reload.quantity }.by(3)
      end

      it 'returns a success message' do
        post_create
        expect(JSON.parse(response.body)['message']).to eq('Stock created successfully.')
      end

      it 'returns a 201 Created status' do
        post_create
        expect(response).to have_http_status(:created)
      end
    end

    context 'when stock creation fails' do
      let(:params) { invalid_params }

      it 'does not change the stock quantity' do
        expect { post_create }.not_to change { stock.reload.quantity }
      end

      it 'returns an error message' do
        post_create
        expect(JSON.parse(response.body)['errors']).to eq('Error creating the stock.')
      end

      it 'returns a 422 Unprocessable Entity status' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when warehouse_id is not present or invalid' do
      let(:params) { valid_params.merge(warehouse_id: -1) }

      it 'does not change the stock quantity' do
        expect { post_create }.not_to change { stock.reload.quantity }
      end

      it 'returns a 422 Unprocessable Entity status' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when product_id is not present or invalid' do
      let(:params) { valid_params.merge(product_id: -1) }

      it 'does not change the stock quantity' do
        expect { post_create }.not_to change { stock.reload.quantity }
      end

      it 'returns a 422 Unprocessable Entity status' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when there is no stock record for the given warehouse and product' do
      let(:new_product) { create(:product) }
      let(:params) { { warehouse_id: warehouse.id, product_id: new_product.id, quantity: 5 } }

      it 'creates a new stock record' do
        expect { post_create }.to change { Stock.count }.by(1)
      end

      it 'sets the quantity of the new stock record to 5' do
        post_create
        new_stock = Stock.find_by(warehouse: warehouse, product: new_product)
        expect(new_stock.quantity).to eq(5)
      end

      it 'returns a success message' do
        post_create
        expect(JSON.parse(response.body)['message']).to eq('Stock created successfully.')
      end

      it 'returns a 201 Created status' do
        post_create
        expect(response).to have_http_status(:created)
      end
    end
  end
end
