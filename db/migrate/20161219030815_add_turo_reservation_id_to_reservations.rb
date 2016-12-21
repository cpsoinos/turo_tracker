class AddTuroReservationIdToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :turo_reservation_id, :string
  end
end
