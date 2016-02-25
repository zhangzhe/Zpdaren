class AddClassificationIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :classification_id, :integer
    add_index :jobs, :classification_id
  end
end
