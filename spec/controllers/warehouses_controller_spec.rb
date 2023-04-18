# frozen_string_literal: true

# spec/controllers/warehouses_controller_spec.rb

require 'rails_helper'

RSpec.describe WarehousesController, type: :controller do
  describe 'GET #index' do
    let!(:warehouse1) { create(:warehouse) }
    let!(:warehouse2) { create(:warehouse) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all warehouses' do
      get :index
      expect(controller.instance_variable_get(:@warehouses)).to eq([warehouse1, warehouse2])
    end
  end

  describe 'GET #show' do
    let!(:warehouse) { create(:warehouse) }

    it 'returns a success response' do
      get :show, params: { id: warehouse.to_param }
      expect(response).to be_successful
    end

    it 'returns the correct warehouse' do
      get :show, params: { id: warehouse.to_param }
      expect(controller.instance_variable_get(:@warehouse)).to eq(warehouse)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { warehouse: { code: 'ABC123' } } }

    context 'with valid params' do
      it 'creates a new Warehouse' do
        expect do
          post :create, params: valid_attributes
        end.to change(Warehouse, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { warehouse: { code: '' } } }

      it 'does not create a new Warehouse' do
        expect do
          post :create, params: invalid_attributes
        end.to_not change(Warehouse, :count)
      end

      it 'returns an unprocessable entity response' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let!(:warehouse) { create(:warehouse) }
    let(:new_code) { 'DEF456' }
    let(:valid_attributes) { { warehouse: { code: new_code } } }

    context 'with valid params' do
      it 'updates the requested warehouse' do
        put :update, params: { id: warehouse.to_param }.merge(valid_attributes)
        warehouse.reload
        expect(warehouse.code).to eq(new_code)
      end

      it 'returns a success response' do
        put :update, params: { id: warehouse.to_param }.merge(valid_attributes)
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { warehouse: { code: '' } } }

      it 'returns an unprocessable entity response' do
        put :update, params: { id: warehouse.to_param }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:warehouse) { create(:warehouse) }

    it 'destroys the requested warehouse' do
      expect do
        delete :destroy, params: { id: warehouse.to_param }
      end.to change(Warehouse, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { id: warehouse.to_param }
      expect(response).to be_successful
    end
  end
end
