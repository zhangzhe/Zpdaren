class AddDeletedAtToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :deleted_at, :datetime
  end
end
