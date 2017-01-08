class Expense < ApplicationRecord
  belongs_to :vehicle
  mount_uploader :receipt, PhotoUploader

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

end
