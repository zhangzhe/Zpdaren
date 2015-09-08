class CreateConcerns < ActiveRecord::Migration
  def change
    create_table :concerns do |t|
      t.integer :supplier_id
      t.integer :job_id

      t.timestamps
    end

    add_index :concerns, :supplier_id
    add_index :concerns, :job_id
  end
end
