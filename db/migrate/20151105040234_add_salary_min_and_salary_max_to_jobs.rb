class AddSalaryMinAndSalaryMaxToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :salary_min, :integer, default: 0
    add_column :jobs, :salary_max, :integer, default: 0
  end
end
