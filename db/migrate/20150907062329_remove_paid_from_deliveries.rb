class RemovePaidFromDeliveries < ActiveRecord::Migration
  def change
    remove_column :deliveries, :paid
  end
end
