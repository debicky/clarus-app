# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  belongs_to :stock

  before_validation :set_default_status, on: :create
  # rename new to initial to use enum?
  validates :status, presence: true, inclusion: { in: %w[new dispatched] }

  def dispatched?
    status == 'dispatched'
  end

  private

  def set_default_status
    self.status ||= 'new'
  end
end