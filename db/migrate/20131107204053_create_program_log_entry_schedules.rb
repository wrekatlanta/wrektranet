class CreateProgramLogSchedules < ActiveRecord::Migration
  def change
    create_table :program_log_schedules do |t|
      t.references :program_log_entry, index: true
      t.date :start_date
      t.date :expiration_date
      t.time :start_time, null: true
      t.time :end_time, null: true
      t.integer :repeat_interval, default: 0
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
