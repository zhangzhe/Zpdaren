class RemoveDrawings < ActiveRecord::Migration
  def change
    drop_table :drawings
  end
end
