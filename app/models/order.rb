# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  belongs_to :stock

  validates :status, presence: true, inclusion: { in: %w[new dispatched] }
  # enum / moze state machine?

  # DODAC RSWAG GEMA dla swaggera
  # obsluga bledow
  # https://medium.com/@sushildamdhere/how-to-document-rest-apis-with-swagger-and-ruby-on-rails-ae4e13177f5d
end
