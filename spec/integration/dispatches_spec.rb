require 'swagger_helper'

RSpec.describe 'Dispatches API', type: :request do
  path '/orders/{order_id}/dispatches' do
  let(:order) { create(:order) }
    let(:order_id) { order.id }

    post 'Create dispatch for order' do
      tags 'Dispatches'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order_id, in: :path, type: :integer

      response '200', 'Order dispatched and stock removed from the system.' do
        before { allow(OrderDispatcher).to receive(:new).and_return(double(call: true)) }

        run_test! do |response|
          expect(JSON.parse(response.body)).to eq('message' => 'Order dispatched and stock removed from the system.')
        end
      end

      response '422', 'Cannot dispatch an already dispatched order.' do
        let!(:dispatched_order) { create(:order, :dispatched) }
        let(:order_id) { dispatched_order.id }

        run_test! do |response|
          expect(JSON.parse(response.body)).to eq('errors' => 'Cannot dispatch an already dispatched order.')
        end
      end

      response '422', 'Invalid record' do
        before { allow_any_instance_of(OrderDispatcher).to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(order)) }

        run_test! do |response|
          expect(response.body).to eq(order.errors.to_json)
        end
      end

      response '404', 'Order not found' do
        let(:order_id) { -1 }

        run_test! do |response|
          expect(JSON.parse(response.body)).to eq('error' => 'Order not found')
        end
      end
    end
  end
end
