# frozen_string_literal: true

class StockCreator
  def initialize(stock:)
    @stock = stock
  end

  def call
    create_stock(@stock)
  end

  private

  def create_stock(stock)
    ActiveRecord::Base.transaction do
      locked_stock = stock.lock!
      existing_stock = Stock.find_by(warehouse: locked_stock.warehouse, product: locked_stock.product)

      if existing_stock
        locked_existing_stock = existing_stock.lock!
        locked_existing_stock.quantity += locked_stock.quantity.to_i
        locked_existing_stock.save!
      else
        locked_stock.save!
      end
    end

    true
    # should I return model validation?
  rescue ActiveRecord::RecordInvalid
    false
  end
end
