class AddSupplierIdToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :supplier_id, :integer
  end
end
