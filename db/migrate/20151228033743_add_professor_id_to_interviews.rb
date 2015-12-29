class AddProfessorIdToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :professor_id, :integer
    add_index :interviews, :professor_id
  end
end
