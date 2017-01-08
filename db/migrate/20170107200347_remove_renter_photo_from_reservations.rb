class RemoveRenterPhotoFromReservations < ActiveRecord::Migration[5.0]
  def change
    remove_column :reservations, :renter_photo
  end
end
