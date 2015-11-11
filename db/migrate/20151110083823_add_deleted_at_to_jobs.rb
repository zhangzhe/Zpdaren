class AddDeletedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :deleted_at, :datetime
  end
end
