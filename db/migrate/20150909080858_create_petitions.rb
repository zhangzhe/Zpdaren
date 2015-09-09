class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.integer :recruiter_id
      t.integer :job_id
      t.text :reason
      t.string :state
    end
  end
end
