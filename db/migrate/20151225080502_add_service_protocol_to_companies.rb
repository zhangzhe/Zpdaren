class AddServiceProtocolToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :service_protocol, :text
  end
end
