class AddTuroIdToRenters < ActiveRecord::Migration[5.0]
  def change
    add_column :renters, :turo_id, :string
  end
end
