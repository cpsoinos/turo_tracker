class Toll < ApplicationRecord
  belongs_to :vehicle
  # belongs_to :trip

  monetize :amount_cents, with_model_currency: :currency
end
