class AddJobIdToMoneyTransfers < ActiveRecord::Migration
  def change
    add_column :money_transfers, :job_id, :integer
    add_index :money_transfers, :job_id
  end
end
