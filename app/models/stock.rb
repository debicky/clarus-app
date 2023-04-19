# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product

  validates :warehouse, presence: true
  validates :product, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
