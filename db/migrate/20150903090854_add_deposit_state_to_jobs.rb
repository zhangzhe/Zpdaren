class AddDepositStateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :deposit, :integer
    add_column :jobs, :state, :string
  end
end
