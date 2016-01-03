class AddPriorityToTags < ActiveRecord::Migration
  def change
    add_column :tags, :priority, :integer
  end
end
