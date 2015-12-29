class AddReplyBeginAtAndReplyEndAtToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :reply_begin_at, :datetime
    add_column :interviews, :reply_end_at, :datetime
  end
end
