class AddParentIdToComments < ActiveRecord::Migration
  def change
    remove_index :comments, column: [:comment_id]
    remove_column :comments, :comment_id, :integer
    add_column :comments, :parent_id, :integer
    add_index "comments", ["parent_id"]
  end
end
