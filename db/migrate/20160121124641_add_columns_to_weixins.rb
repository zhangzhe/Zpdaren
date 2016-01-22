class AddColumnsToWeixins < ActiveRecord::Migration
  def change
    add_column :weixins, :nickname, :string
    add_column :weixins, :sex, :string
    add_column :weixins, :city, :string
    add_column :weixins, :province, :string
    add_column :weixins, :headimgurl, :string
  end
end
