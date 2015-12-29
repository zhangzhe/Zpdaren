class AddProfessorTitleAndBriefToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :professor_title, :string
    add_column :interviews, :brief, :text
    remove_column :interviews, :title, :string
  end
end
