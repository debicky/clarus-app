# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WarehousesController, type: :controller do
  describe 'GET #index' do
    subject(:get_index) { get :index }

    let(:warehouses) { create_list(:warehouse, 2) }
    before(:each) do
      warehouses
    end

    it 'returns a success response' do
      get_index
      expect(response).to be_successful
    end

    it 'returns all warehouses' do
      get_index
      expect(controller.instance_variable_get(:@warehouses)).to match_array(warehouses)
    end
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { id: warehouse.id } }

    let(:warehouse) { create(:warehouse) }

    before(:each) do
      warehouse
    end

    it 'returns a success response' do
      get_show
      expect(response).to be_successful
    end

    it 'returns the correct warehouse' do
      get_show
      expect(controller.instance_variable_get(:@warehouse)).to eq(warehouse)
    end
  end

  describe 'POST #create' do
    subject(:post_create) { post :create, params: attributes }

    let(:attributes) { { warehouse: { code: 'ABC123' } } }

    context 'with valid params' do
      it 'creates a new Warehouse' do
        expect { post_create }.to change(Warehouse, :count).by(1)
      end

      it 'returns a success response' do
        post_create
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:attributes) { { warehouse: { code: '' } } }

      it 'does not create a new Warehouse' do
        expect { post_create }.to_not change(Warehouse, :count)
      end

      it 'returns an unprocessable entity response' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    subject(:put_update) { put :update, params: { id: warehouse.id }.merge(attributes) }

    let(:warehouse) { create(:warehouse) }
    let(:new_code) { 'DEF456' }
    let(:attributes) { { warehouse: { code: new_code } } }

    before(:each) do
      warehouse
    end

    context 'with valid params' do
      it 'updates the requested warehouse' do
        put_update
        warehouse.reload
        expect(warehouse.code).to eq(new_code)
      end

      it 'returns a success response' do
        put_update
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      let(:attributes) { { warehouse: { code: '' } } }

      it 'returns an unprocessable entity response' do
        put_update
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete :destroy, params: { id: warehouse.id } }

    let(:warehouse) { create(:warehouse) }

    before(:each) do
      warehouse
    end

    it 'destroys the requested warehouse' do
      expect { delete_destroy }.to change(Warehouse, :count).by(-1)
    end

    it 'returns a success response' do
      delete_destroy
      expect(response).to be_successful
    end
  end
end
