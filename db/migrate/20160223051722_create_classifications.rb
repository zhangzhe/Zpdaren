class CreateClassifications < ActiveRecord::Migration
  def change
    create_table :classifications do |t|
      t.string :name
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
