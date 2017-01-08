class AddRenterToReservations < ActiveRecord::Migration[5.0]
  def change
    add_reference :reservations, :renter, foreign_key: true
  end
end
