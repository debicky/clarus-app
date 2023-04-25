# frozen_string_literal: true

# spec/controllers/dispatches_controller_spec.rb
require 'rails_helper'

RSpec.describe DispatchesController, type: :controller do
  let(:warehouse) { create(:warehouse) }
  let(:product) { create(:product) }
  let(:stock) { create(:stock, warehouse: warehouse, product: product, quantity: 5) }
  let(:new_order) { create(:order, warehouse: warehouse, product: product, stock: stock, status: 'new') }
  let(:dispatched_order) { create(:order, warehouse: warehouse, product: product, stock: stock, status: 'dispatched') }

  describe 'POST #create' do
    context 'when order status is new' do
      before { post :create, params: { order_id: new_order.id } }

      it 'changes order status to dispatched' do
        expect(new_order.reload.status).to eq('dispatched')
      end

      it 'decreases stock quantity by 1' do
        expect(stock.reload.quantity).to eq(4)
      end

      it 'returns a success message' do
        expect(JSON.parse(response.body)['message']).to eq('Order dispatched and stock removed from the system.')
      end

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when order status is dispatched' do
      before { post :create, params: { order_id: dispatched_order.id } }

      it 'does not change order status' do
        expect(dispatched_order.reload.status).to eq('dispatched')
      end

      it 'does not change stock quantity' do
        expect(stock.reload.quantity).to eq(5)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['errors']).to eq('Cannot dispatch an already dispatched order.')
      end

      it 'returns a 422 Unprocessable Entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
