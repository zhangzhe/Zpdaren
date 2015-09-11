class RenameCompanyIdToUserIdForJobs < ActiveRecord::Migration
  def change
    rename_column :jobs, :company_id, :user_id
  end
end
