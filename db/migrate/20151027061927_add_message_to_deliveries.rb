class AddMessageToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :message, :string
    remove_column :resumes, :message, :string
  end
end
