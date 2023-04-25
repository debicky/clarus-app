# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  belongs_to :stock

  validates :status, presence: true, inclusion: { in: %w[new dispatched] }

  def dispatch
    return false unless status == 'new'

    self.status = 'dispatched'
    save
  end
end
