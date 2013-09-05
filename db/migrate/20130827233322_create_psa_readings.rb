class CreatePsaReadings < ActiveRecord::Migration
  def change
    create_table :psa_readings do |t|
      t.integer :user_id
      t.integer :psa_id

      t.timestamps
    end
  end
end
