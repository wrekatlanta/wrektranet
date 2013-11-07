class CreateProgramLogEntrySchedules < ActiveRecord::Migration
  def change
    create_table :program_log_entry_schedules do |t|
      t.references :program_log_entry, index: true
      t.date :start_date
      t.date :expiration_date
      t.time :start_time
      t.time :end_time
      t.integer :repeat_interval
      t.boolean :sunday, default: false
      t.boolean :monday, default: false
      t.boolean :tuesday, default: false
      t.boolean :wednesday, default: false
      t.boolean :thursday, default: false
      t.boolean :friday, default: false
      t.boolean :saturday, default: false

      t.timestamps
    end
  end
end
