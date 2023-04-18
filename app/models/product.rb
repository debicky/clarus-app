class Product < ApplicationRecord
  has_many :stocks

  validates :description, presence: true
  validates :code, presence: true
end
