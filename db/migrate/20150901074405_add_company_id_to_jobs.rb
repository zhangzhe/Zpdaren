class AddCompanyIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :company_id, :integer
    add_index :jobs, :company_id
  end
end
