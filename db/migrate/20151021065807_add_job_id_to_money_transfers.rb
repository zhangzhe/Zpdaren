class AddJobIdToMoneyTransfers < ActiveRecord::Migration
  def change
    add_column :money_transfers, :job_id, :integer
  end
end
