class AddMobileToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :mobile, :string
  end
end
