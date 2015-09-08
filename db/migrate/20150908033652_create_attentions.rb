class CreateAttentions < ActiveRecord::Migration
  def change
    create_table :attentions do |t|
      t.integer :supplier_id
      t.integer :job_id

      t.timestamps
    end

    add_index :attentions, :supplier_id
    add_index :attentions, :job_id
  end
end
