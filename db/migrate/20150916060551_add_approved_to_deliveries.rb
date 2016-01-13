class AddApprovedToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :approved, :boolean
  end
end
