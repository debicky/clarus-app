# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  has_many :orders
  # add dependencies?

  validates :warehouse, presence: true
  validates :product, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :with_product_and_warehouse, ->(product, warehouse) { where(product: product, warehouse: warehouse) }
  scope :with_positive_quantity, -> { where('quantity > 0') }
end
