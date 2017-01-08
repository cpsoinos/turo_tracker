class AddCostsToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_monetize :vehicles, :loan_payment
    add_monetize :vehicles, :insurance_payment
    add_monetize :vehicles, :parking_payment
  end
end
