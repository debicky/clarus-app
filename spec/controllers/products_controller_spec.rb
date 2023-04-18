require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "returns all products" do
      product1 = create(:product)
      product2 = create(:product)

      get :index
      expect(controller.instance_variable_get(:@products)).to include(product1, product2)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      product = create(:product)

      get :show, params: { id: product.id }
      expect(response).to be_successful
    end

    it "returns the correct product" do
      product = create(:product)

      get :show, params: { id: product.id }
      expect(controller.instance_variable_get(:@product)).to eq(product)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new product" do
        expect {
          post :create, params: { product: attributes_for(:product) }
        }.to change(Product, :count).by(1)
      end

      it "returns a successful response" do
        post :create, params: { product: attributes_for(:product) }
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      it "does not create a new product" do
        expect {
          post :create, params: { product: attributes_for(:product, code: nil) }
        }.to_not change(Product, :count)
      end

      it "returns an error response" do
        post :create, params: { product: attributes_for(:product, code: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the product" do
        product = create(:product)

        patch :update, params: { id: product.id, product: { code: "NEWCODE" } }
        product.reload

        expect(product.code).to eq("NEWCODE")
      end

      it "returns a successful response" do
        product = create(:product)

        patch :update, params: { id: product.id, product: { code: "NEWCODE" } }
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      it "does not update the product" do
        product = create(:product)

        patch :update, params: { id: product.id, product: { code: nil } }
        product.reload

        expect(product.code).to_not be_nil
      end

      it "returns an error response" do
        product = create(:product)

        patch :update, params: { id: product.id, product: { code: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:product) { create(:product) }

    it "deletes the product" do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
    end

    it "returns a successful response" do
      delete :destroy, params: { id: product.id }
      expect(response).to be_successful
    end

    it "returns the deleted product" do
      delete :destroy, params: { id: product.id }
      expect(controller.instance_variable_get(:@product)).to eq(product)
    end
  end
end