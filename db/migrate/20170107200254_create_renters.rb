class CreateRenters < ActiveRecord::Migration[5.0]
  def change
    create_table :renters do |t|
      t.string :name
      t.string :phone
      t.string :photo
    end
  end
end
