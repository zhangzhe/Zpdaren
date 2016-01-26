class RenameUsersUidToUsersOpenId < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :open_id
  end
end
