class CreateTransmitterLogEntries < ActiveRecord::Migration
  def change
    create_table :transmitter_log_entries do |t|
      t.datetime :sign_in
      t.datetime :sign_out
      t.integer :user_id
      t.boolean :automation

      t.timestamps
    end
  end
end
