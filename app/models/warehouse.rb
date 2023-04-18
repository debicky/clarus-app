# frozen_string_literal: true

class Warehouse < ApplicationRecord
  has_many :stocks
end
