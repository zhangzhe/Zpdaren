class DropTableCommenterDetails < ActiveRecord::Migration
  def change
    drop_table :commenter_details
  end
end
