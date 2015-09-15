class AddAutoDeliveryToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :auto_delivery, :boolean
    Resume.where("auto_delivery is null").each { |resume| resume.update_attribute(:auto_delivery, true) }
  end
end
