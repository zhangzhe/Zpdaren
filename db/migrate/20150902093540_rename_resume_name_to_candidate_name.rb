class RenameResumeNameToCandidateName < ActiveRecord::Migration
  def change
    rename_column :resumes, :name, :candidate_name
  end
end
