# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockBalance, type: :model do
  describe 'associations' do
    it 'belongs to warehouse' do
      order_association = Order.reflect_on_association(:warehouse)
      expect(order_association.macro).to eq(:belongs_to)
    end

    it 'belongs to product' do
      order_association = Order.reflect_on_association(:product)
      expect(order_association.macro).to eq(:belongs_to)
    end

    it 'belongs to stock' do
      order_association = Order.reflect_on_association(:stock)
      expect(order_association.macro).to eq(:belongs_to)
    end
  end

  describe '#available_stocks' do
    let(:warehouse) { create(:warehouse) }
    let(:product) { create(:product) }
    let(:stock) { create(:stock, warehouse: warehouse, product: product, quantity: 10) }
    let(:stock_balance) { create(:stock_balance, warehouse: warehouse, product: product, stock: stock) }

    it 'returns the available stock quantity' do
      expect(stock_balance.available_stocks).to eq(10)
    end
  end

  describe '#ordered_stocks' do
    let(:warehouse) { create(:warehouse) }
    let(:product) { create(:product) }
    let(:stock) { create(:stock, warehouse: warehouse, product: product, quantity: 20) }
    let!(:new_order) { create(:order, warehouse: warehouse, product: product, stock: stock, status: 'new') }
    let!(:dispatched_order) do
      create(:order, warehouse: warehouse, product: product, stock: stock, status: 'dispatched')
    end
    let(:stock_balance) { create(:stock_balance, warehouse: warehouse, product: product, stock: stock) }

    it 'returns the count of dispatched orders' do
      expect(stock_balance.ordered_stocks).to eq(1)
    end
  end
end
