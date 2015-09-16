class AddApprovedToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :approved, :boolean
    Delivery.all.each do |delivery|
      delivery.update_attribute(:approved, true) if delivery.resume.approved?
    end
  end
end
