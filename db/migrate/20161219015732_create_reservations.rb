class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.references :vehicle, foreign_key: true
      t.string :renter
      t.datetime :start_date
      t.datetime :end_date
      t.monetize :expected_earnings
      t.integer :miles_included
      t.string :renter_photo
      t.timestamps
    end
  end
end
