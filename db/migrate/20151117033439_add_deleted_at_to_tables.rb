class AddDeletedAtToTables < ActiveRecord::Migration
  def change
    # add_column :users, :deleted_at, :datetime
    # add_column :wallets, :deleted_at, :datetime
    # add_column :weixins, :deleted_at, :datetime
    # add_column :companies, :deleted_at, :datetime
    # add_column :resumes, :deleted_at, :datetime
    add_column :money_transfers, :deleted_at, :datetime
    add_column :refund_requests, :deleted_at, :datetime
    add_column :watchings, :deleted_at, :datetime
    add_column :deliveries, :deleted_at, :datetime
    add_column :rejections, :deleted_at, :datetime
  end
end
