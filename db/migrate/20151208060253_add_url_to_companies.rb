class AddUrlToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :url, :text
  end
end
