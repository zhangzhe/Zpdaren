class ChangeDeliveriesIndex < ActiveRecord::Migration
  def change
    remove_index :deliveries, :resume_id_and_job_id
    add_index :deliveries, [:resume_id, :job_id], :unique => true
  end
end
