class RemoveApprovedFromDeliveries < ActiveRecord::Migration
  def change
    remove_column :deliveries, :approved, :boolean
  end
end
