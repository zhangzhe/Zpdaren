class RenameResumesCheckedToReviewed < ActiveRecord::Migration
  def change
    rename_column :resumes, :checked, :reviewed
  end
end
