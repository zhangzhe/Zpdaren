class AddMessageToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :message, :string
  end
end
