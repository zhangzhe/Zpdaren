class RenameAttentionsToWatchings < ActiveRecord::Migration
  def change
    drop_table :attentions

    create_table :watchings do |t|
      t.integer :supplier_id
      t.integer :job_id

      t.timestamps
    end

    add_index :watchings, :supplier_id
    add_index :watchings, :job_id
  end
end
