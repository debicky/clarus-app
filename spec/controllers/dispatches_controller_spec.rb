# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DispatchesController, type: :controller do
  let(:warehouse) { create(:warehouse) }
  let(:product) { create(:product) }
  let(:stock) { create(:stock, warehouse: warehouse, product: product, quantity: 5) }
  let(:new_order) { create(:order, stock: stock, status: 'new') }
  let(:dispatched_order) { create(:order, stock: stock, status: 'dispatched') }

  describe 'POST #create' do
    context 'when order status is new' do
      subject(:post_create) { post :create, params: { order_id: new_order.id } }

      it 'changes order status to dispatched' do
        post_create
        expect(new_order.reload.status).to eq('dispatched')
      end

      it 'decreases stock quantity by 1' do
        expect { post_create }.to change { stock.reload.quantity }.by(-1)
      end

      it 'returns a success message' do
        post_create
        expect(JSON.parse(response.body)['message']).to eq('Order dispatched and stock removed from the system.')
      end

      it 'returns a 200 OK status' do
        post_create
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when order status is dispatched' do
      subject(:post_create) { post :create, params: { order_id: dispatched_order.id } }

      it 'does not change order status' do
        expect { post_create }.not_to change { dispatched_order.reload.status }
      end

      it 'does not change stock quantity' do
        expect { post_create }.not_to change { stock.reload.quantity }
      end

      it 'returns an error message' do
        post_create
        expect(JSON.parse(response.body)['errors']).to eq('Cannot dispatch an already dispatched order.')
      end

      it 'returns a 422 Unprocessable Entity status' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
