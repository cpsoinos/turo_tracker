class Vehicle < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  has_many :trips
  has_many :tolls
  has_many :reservations
  has_many :webhooks
  has_many :expenses

  accepts_nested_attributes_for :expenses

  monetize :loan_payment_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :insurance_payment_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :parking_payment_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  def name
    "#{make} #{model}"
  end

  def self.remote_objects
    Automatic::Models::Vehicles.all.to_a
  end

  def remote_object
    Automatic::Models::Vehicles.find_by_id(remote_id)
  end

end
