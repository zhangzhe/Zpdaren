class AddMobileAndEmailAndDescriptionToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :mobile, :string
    add_column :resumes, :email, :string
    add_column :resumes, :description, :text
    add_column :resumes, :checked, :boolean, default: false
  end
end
