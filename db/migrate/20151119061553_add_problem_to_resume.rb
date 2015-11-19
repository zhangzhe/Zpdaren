class AddProblemToResume < ActiveRecord::Migration
  def change
    add_column :resumes, :problem, :text
  end
end
