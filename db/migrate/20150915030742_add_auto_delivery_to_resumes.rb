class AddAutoDeliveryToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :auto_delivery, :boolean
  end
end
