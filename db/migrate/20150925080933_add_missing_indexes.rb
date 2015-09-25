class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :money_transfers, :wallet_id
    add_index :refund_requests, :job_id
    add_index :rejections, :delivery_id
    add_index :weixins, :user_id
  end
end
