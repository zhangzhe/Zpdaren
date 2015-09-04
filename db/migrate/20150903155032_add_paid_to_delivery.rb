class AddPaidToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :paid, :boolean, default: false
  end
end
