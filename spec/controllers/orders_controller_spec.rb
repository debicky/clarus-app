# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:warehouse) { FactoryBot.create(:warehouse) }
  let(:product) { FactoryBot.create(:product) }
  let(:stock) { FactoryBot.create(:stock, warehouse: warehouse, product: product, quantity: 1) }

  before(:each) do
    stock
  end

  describe 'POST #create' do
    subject(:post_create) { post :create, params: { warehouse_id: warehouse.id, product_id: product.id } }

    context 'when there is available stock for the selected warehouse and product' do
      it 'creates a new order' do
        post_create
        expect(response).to have_http_status(:created)
        expect(Order.count).to eq(1)
        expect(Order.last.warehouse).to eq(warehouse)
        expect(Order.last.product).to eq(product)
        expect(Order.last.stock).to eq(stock)
        expect(Order.last.status).to eq('new')
      end

      it 'updates the available quantity of the stock' do
        expect do
          post_create
        end.to change { stock.reload.quantity }.from(1).to(0)
      end
    end

    context 'when there is no available stock for the selected warehouse and product' do
      before do
        stock.update(quantity: 0)
      end

      it 'does not create a new order' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.count).to eq(0)
      end

      it 'returns an error message' do
        post_create
        expect(JSON.parse(response.body)['error']).to eq('No stock available for the selected product and warehouse')
      end
    end
  end
end
