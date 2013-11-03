class CreatePLogs < ActiveRecord::Migration
  def change
    create_table :p_logs do |t|
      t.string :time
      t.string :Event
      t.text :description
      t.timedate :start_date
      t.timedate :expiration_date	

      t.timestamps
    end
  end
end
