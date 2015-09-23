class AddFinalPaymentIdToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :final_payment_id, :integer
  end
end
