class RenameViewedAtToReadAtForDeliveries < ActiveRecord::Migration
  def change
    rename_column :deliveries, :viewed_at, :read_at
  end
end
