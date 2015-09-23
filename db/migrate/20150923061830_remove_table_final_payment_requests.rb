class RemoveTableFinalPaymentRequests < ActiveRecord::Migration
  def change
    drop_table :final_payment_requests
  end
end
