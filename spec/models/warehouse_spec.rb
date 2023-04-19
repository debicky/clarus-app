# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  let(:warehouse) { build(:warehouse) }

  describe 'associations' do
    it 'has many stocks' do
      warehouse = Warehouse.reflect_on_association(:stocks)
      expect(warehouse.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'validates presence of code' do
      warehouse.code = nil
      expect(warehouse.valid?).to eq(false)
      expect(warehouse.errors[:code]).to include("can't be blank")
    end
  end
end
