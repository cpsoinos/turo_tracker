class Vehicle < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  has_many :trips
  has_many :tolls
  has_many :reservations
  has_many :webhooks

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
