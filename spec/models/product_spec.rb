# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { described_class.new }

  describe 'associations' do
    let(:association) { described_class.reflect_on_association(:stocks) }

    it 'has many stocks' do
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'is invalid without a description' do
      product.description = nil
      product.code = 'ABC'
      expect(product).to_not be_valid
    end

    it 'is invalid without a code' do
      product.description = 'Some product'
      product.code = nil
      expect(product).to_not be_valid
    end
  end
end
