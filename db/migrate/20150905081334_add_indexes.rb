class AddIndexes < ActiveRecord::Migration
  def change
    add_index :companies, :user_id
    add_index :deliveries, [:resume_id, :job_id]
    add_index :wallets, :user_id
  end
end
