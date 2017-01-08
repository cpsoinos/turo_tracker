class Renter < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  has_many :trips

end
