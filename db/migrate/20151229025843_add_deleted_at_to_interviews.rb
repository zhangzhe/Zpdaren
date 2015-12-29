class AddDeletedAtToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :deleted_at, :datetime
  end
end
