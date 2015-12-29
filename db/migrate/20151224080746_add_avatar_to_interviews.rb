class AddAvatarToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :avatar, :string
  end
end
