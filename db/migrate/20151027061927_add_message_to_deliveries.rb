class AddMessageToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :message, :string
    Resume.all.each do |resume|
      resume.deliveries.update_all(message: resume.message )
    end
    remove_column :resumes, :message, :string
  end
end
