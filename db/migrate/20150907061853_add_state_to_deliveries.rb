class AddStateToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :state, :string
  end
end
