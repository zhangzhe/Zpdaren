class AddDeletedAtToTables < ActiveRecord::Migration
  def change
    add_column :money_transfers, :deleted_at, :datetime
    add_column :refund_requests, :deleted_at, :datetime
    add_column :watchings, :deleted_at, :datetime
    add_column :deliveries, :deleted_at, :datetime
    add_column :rejections, :deleted_at, :datetime
  end
end
