class AddMessageToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :message, :string
  end
end
