# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    let(:products) { create_list(:product, 2) }

    before(:each) do
      products
    end

    it 'returns a successful response' do
      subject
      expect(response).to be_successful
    end

    it 'returns all products' do
      subject
      expect(controller.instance_variable_get(:@products)).to match_array(products)
    end
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { id: product.id } }

    let(:product) { create(:product) }

    before(:each) do
      product
    end

    it 'returns a successful response' do
      get_show
      expect(response).to be_successful
    end

    it 'returns the correct product' do
      get_show
      expect(controller.instance_variable_get(:@product)).to eq(product)
    end
  end

  describe 'POST #create' do
    subject(:post_create) { post :create, params: { product: product_params } }

    let(:product_params) { attributes_for(:product) }

    context 'with valid parameters' do
      it 'creates a new product' do
        expect { post_create }.to change(Product, :count).by(1)
      end

      it 'returns a successful response' do
        post_create
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      let(:product_params) { attributes_for(:product, code: nil) }

      it 'does not create a new product' do
        expect { post_create }.to_not change(Product, :count)
      end

      it 'returns an error response' do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    subject(:patch_update) { patch :update, params: { id: product.id, product: product_params } }

    let(:product) { create(:product) }

    context 'with valid parameters' do
      let(:product_params) { { code: 'NEWCODE' } }

      it 'updates the product' do
        patch_update
        product.reload
        expect(product.code).to eq('NEWCODE')
      end

      it 'returns a successful response' do
        patch_update
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      let(:product_params) { { code: nil } }

      it 'does not update the product' do
        patch_update
        product.reload
        expect(product.code).to_not be_nil
      end

      it 'returns an error response' do
        patch_update
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete :destroy, params: { id: product.id } }

    let(:product) { create(:product) }

    before(:each) do
      product
    end

    it 'deletes the product' do
      delete_destroy
      expect { product.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'returns a successful response' do
      delete_destroy
      expect(response).to be_successful
    end

    it 'returns the deleted product' do
      delete_destroy
      expect(controller.instance_variable_get(:@product)).to eq(product)
    end
  end
end
