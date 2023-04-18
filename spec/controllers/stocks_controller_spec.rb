# frozen_string_literal: true

# spec/controllers/stocks_controller_spec.rb

require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  describe 'GET #index' do
    let!(:stock1) { create(:stock) }
    let!(:stock2) { create(:stock) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all stocks' do
      get :index
      expect(controller.instance_variable_get(:@stocks)).to eq([stock1, stock2])
    end
  end

  describe 'GET #show' do
    let!(:stock) { create(:stock) }

    it 'returns a success response' do
      get :show, params: { id: stock.to_param }
      expect(response).to be_successful
    end

    it 'returns the correct stock' do
      get :show, params: { id: stock.to_param }
      expect(controller.instance_variable_get(:@stock)).to eq(stock)
    end
  end
end
