class AddRemarkToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :remark, :text
  end
end
