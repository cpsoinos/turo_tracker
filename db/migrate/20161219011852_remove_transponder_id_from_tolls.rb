class RemoveTransponderIdFromTolls < ActiveRecord::Migration[5.0]
  def change
    remove_column :tolls, :transponder_id, :string
  end
end
