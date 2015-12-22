class AddIndexToMoneyTransfers < ActiveRecord::Migration
  def change
    add_index :money_transfers, :job_id
  end
end
