class Vehicle < ApplicationRecord
  has_many :trips

  def remote_object
    Automatic::Models::Vehicles.find_by_id(remote_id)
  end

end
