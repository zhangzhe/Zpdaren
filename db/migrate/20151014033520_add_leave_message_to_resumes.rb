class AddLeaveMessageToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :leave_message, :string
  end
end
