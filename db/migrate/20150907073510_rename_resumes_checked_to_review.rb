class RenameResumesCheckedToReview < ActiveRecord::Migration
  def change
    rename_column :resumes, :checked, :review
  end
end
