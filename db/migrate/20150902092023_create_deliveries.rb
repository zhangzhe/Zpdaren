class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.integer :resume_id
      t.integer :job_id

      t.timestamps null: false
    end
  end
end
