class AddAvailableToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :available, :boolean
  end
end
