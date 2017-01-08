class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.references :vehicle, foreign_key: true
      t.string :category
      t.monetize :amount
      t.datetime :date
      t.string :receipt
      t.timestamps
    end
  end
end
