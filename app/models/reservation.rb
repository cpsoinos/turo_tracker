class Reservation < ApplicationRecord
  has_many :trips
  belongs_to :vehicle
  mount_uploader :renter_photo, PhotoUploader

end
