class RemoveUselessColumnForMoneyTransfers < ActiveRecord::Migration
  def change
    remove_column :money_transfers, :string
  end
end
