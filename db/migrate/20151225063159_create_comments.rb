class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :commenter_id
      t.string :commenter_name
      t.integer :comment_id
      t.integer :interview_id
      t.text :content

      t.timestamps null: false
    end
    add_index "comments", ["commenter_id"]
    add_index "comments", ["comment_id"]
    add_index "comments", ["interview_id"]
  end
end
