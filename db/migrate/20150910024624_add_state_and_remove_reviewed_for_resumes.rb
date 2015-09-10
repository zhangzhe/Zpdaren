class AddStateAndRemoveReviewedForResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :state, :string
    remove_column :resumes, :reviewed, :boolean
  end
end
