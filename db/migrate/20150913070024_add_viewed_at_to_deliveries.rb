class AddViewedAtToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :viewed_at, :datetime
  end
end
