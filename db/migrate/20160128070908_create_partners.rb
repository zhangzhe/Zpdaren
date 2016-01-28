class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.text :logo
      t.text :url
      t.text :qrcode
    end
  end
end
