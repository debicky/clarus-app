# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:warehouse) { create(:warehouse) }
  let(:product) { create(:product) }

  describe 'associations' do
    it 'belongs to warehouse' do
      stock = Stock.reflect_on_association(:warehouse)
      expect(stock.macro).to eq(:belongs_to)
    end

    it 'belongs to product' do
      stock = Stock.reflect_on_association(:product)
      expect(stock.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'validates presence of warehouse' do
      stock = Stock.new(product: product, quantity: 5)
      expect(stock.valid?).to eq(false)
      expect(stock.errors[:warehouse]).to include('must exist')
    end

    it 'validates presence of product' do
      stock = Stock.new(warehouse: warehouse, quantity: 5)
      expect(stock.valid?).to eq(false)
      expect(stock.errors[:product]).to include('must exist')
    end

    it 'validates presence of quantity' do
      stock = Stock.new(product: product, warehouse: warehouse)
      expect(stock.valid?).to eq(false)
      expect(stock.errors[:quantity]).to include("can't be blank")
    end

    it 'validates quantity is an integer and greater than or equal to 0' do
      stock = Stock.new(product: product, warehouse: warehouse, quantity: -1)
      expect(stock.valid?).to eq(false)
      expect(stock.errors[:quantity]).to include('must be greater than or equal to 0')

      stock.quantity = 0
      expect(stock.valid?).to eq(true)

      stock.quantity = 5.5
      expect(stock.valid?).to eq(false)
      expect(stock.errors[:quantity]).to include('must be an integer')
    end
  end
end
