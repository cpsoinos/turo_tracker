class RemoveIndexFromReservations < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :reservations, column: :renter_id
    remove_index :reservations, :renter_id
  end
end
