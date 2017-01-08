class AddReimbursementsToReservations < ActiveRecord::Migration[5.0]
  def change
    add_monetize :reservations, :reimbursements
  end
end
