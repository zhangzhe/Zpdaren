class AddBonusToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :bonus, :integer
  end
end
