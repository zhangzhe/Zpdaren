class RemoveStateFromResumes < ActiveRecord::Migration
  def change
    remove_column :resumes, :state, :string
  end
end
