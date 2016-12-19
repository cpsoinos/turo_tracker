class RenameTransactionToKindOnTolls < ActiveRecord::Migration[5.0]
  def change
    rename_column :tolls, :transaction, :kind
  end
end
