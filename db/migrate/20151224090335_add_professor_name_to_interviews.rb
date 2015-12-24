class AddProfessorNameToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :professor_name, :string
  end
end
