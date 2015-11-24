class AddPriorityToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :priority, :integer
  end
end
