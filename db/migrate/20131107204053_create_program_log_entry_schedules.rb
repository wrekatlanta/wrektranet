class CreateProgramLogEntrySchedules < ActiveRecord::Migration
  def change
    create_table :program_log_entry_schedules do |t|
      t.references :program_log_entry, index: true
      t.date :start_date
      t.date :expiration_date
      t.time :start_time
      t.time :end_time
      t.integer :repeat_interval
      t.boolean :sunday
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday

      t.timestamps
    end
  end
end
