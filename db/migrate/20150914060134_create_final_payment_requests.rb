class CreateFinalPaymentRequests < ActiveRecord::Migration
  def change
    create_table :final_payment_requests do |t|
      t.integer :job_id
      t.integer :supplier_id
      t.float :money
      t.string :state

      t.timestamps
    end
  end
end
