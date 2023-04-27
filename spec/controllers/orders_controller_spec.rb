# frozen_string_literal: true

# spec/controllers/orders_controller_spec.rb
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

    context 'when product_id is invalid' do
      let(:invalid_product_id) { Product.maximum(:id).to_i + 1 }
      subject(:post_create_invalid_product) do
        post :create, params: { warehouse_id: warehouse.id, product_id: invalid_product_id }
      end

      it 'returns an error message' do
        post_create_invalid_product
        expect(JSON.parse(response.body)['error']).to eq('Product not found')
      end
    end

    context 'when warehouse_id is invalid' do
      let(:invalid_warehouse_id) { Warehouse.maximum(:id).to_i + 1 }
      subject(:post_create_invalid_warehouse) do
        post :create, params: { warehouse_id: invalid_warehouse_id, product_id: product.id }
      end

      it 'returns an error message' do
        expect do
          post_create_invalid_warehouse
        end.to raise_error(ActiveRecord::RecordNotFound,
                           "Couldn't find Warehouse with 'id'=#{invalid_warehouse_id}")
      end
    end

    context 'when saving the order fails due to validation errors' do
      let(:invalid_order) { FactoryBot.build(:order, warehouse: nil, product: nil, stock: nil, status: nil) }

      before do
        invalid_order.validate
        allow_any_instance_of(Order).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(Order.new))
      end

      it 'returns an unprocessable entity status' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new order' do
        post_create
        expect(Order.count).to eq(0)
      end
    end
  end
end
