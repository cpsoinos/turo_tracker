class RemoveNullConstraintsFromReservations < ActiveRecord::Migration[5.0]
  def change
    change_column_null :reservations, :expected_earnings_cents, true
    change_column_null :reservations, :reimbursements_cents, true
    change_column_null :reservations, :renter_id, true
  end
end
