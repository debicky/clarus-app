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
    quantity { 1 }
    association :warehouse
    association :product
  end

  factory :order do
    association :warehouse
    association :product
    association :stock
    status { 'new' }

    trait :dispatched do
      status { 'dispatched' }
    end
  end

  factory :stock_balance do
    association :warehouse
    association :product
    association :stock
  end
end
