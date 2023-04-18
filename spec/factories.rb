# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    code { 'Product' }
    description { 'Description' }
  end

  factory :warehouse do
    code { 'Warehouse code' }
  end

  factory :stock do
    quantity { 123 }
    association :warehouse
    association :product
  end
end
