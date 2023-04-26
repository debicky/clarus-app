# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:warehouse) { create(:warehouse) }
  let(:product) { create(:product) }
  let(:stock) { create(:stock, warehouse: warehouse, product: product, quantity: 1) }
  let(:order) { create(:order, warehouse: warehouse, product: product, stock: stock) }

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

  describe 'validations' do
    it 'validates presence of warehouse' do
      order.warehouse = nil
      expect(order.valid?).to eq(false)
      expect(order.errors[:warehouse]).to include('must exist')
    end

    it 'validates presence of product' do
      order.product = nil
      expect(order.valid?).to eq(false)
      expect(order.errors[:product]).to include('must exist')
    end

    it 'validates presence of stock' do
      order.stock = nil
      expect(order.valid?).to eq(false)
      expect(order.errors[:stock]).to include('must exist')
    end

    it 'validates presence of status' do
      order.status = nil
      expect(order.valid?).to eq(false)
      expect(order.errors[:status]).to include("can't be blank")
    end

    it 'validates inclusion of status in allowed values' do
      order.status = 'invalid_status'
      expect(order.valid?).to eq(false)
      expect(order.errors[:status]).to include('is not included in the list')
    end

    it 'is valid with status "new"' do
      order.status = 'new'
      expect(order.valid?).to eq(true)
    end

    it 'is valid with status "dispatched"' do
      order.status = 'dispatched'
      expect(order.valid?).to eq(true)
    end
  end

  describe 'default attributes' do
    it 'sets the default status to "new"' do
      new_order = Order.create(warehouse: warehouse, product: product, stock: stock)
      expect(new_order.status).to eq('new')
    end
  end
end
