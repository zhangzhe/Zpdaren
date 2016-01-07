class CreateCommenterDetails < ActiveRecord::Migration
  def change
    create_table :commenter_details do |t|
      t.string :nickname
      t.string :sex
      t.string :city
      t.string :province
      t.string :headimgurl
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
