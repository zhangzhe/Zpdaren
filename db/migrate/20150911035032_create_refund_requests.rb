class CreateRefundRequests < ActiveRecord::Migration
  def change
    create_table :refund_requests do |t|
      t.integer :job_id
      t.text :reason
      t.string :state

      t.timestamps null: false
    end
  end
end
