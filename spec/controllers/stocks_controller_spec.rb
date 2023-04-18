# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  describe 'GET #index' do
    subject(:get_index) { get :index }

    let(:stocks) { create_list(:stock, 2) }

    before(:each) do
      stocks
    end

    it 'returns a success response' do
      get_index
      expect(response).to be_successful
    end

    it 'returns all stocks' do
      get_index
      expect(controller.instance_variable_get(:@stocks)).to match_array(stocks)
    end
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { id: stock.id } }

    let(:stock) { create(:stock) }

    before(:each) do
      stock
    end

    it 'returns a success response' do
      get_show
      expect(response).to be_successful
    end

    it 'returns the correct stock' do
      get_show
      expect(controller.instance_variable_get(:@stock)).to eq(stock)
    end
  end
end
