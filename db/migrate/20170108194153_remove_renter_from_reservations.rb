class RemoveRenterFromReservations < ActiveRecord::Migration[5.0]
  def change
    remove_column :reservations, :renter, :string
  end
end
