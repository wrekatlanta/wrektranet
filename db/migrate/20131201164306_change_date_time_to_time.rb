class ChangeDateTimeToTime < ActiveRecord::Migration
  def self.up
      change_column :time_slots, :start_time, :time
      change_column :time_slots, :end_time, :time
  end
  def self.down
      change_column :time_slots, :start_time, :datetime
      change_column :time_slots, :end_time, :datetime
  end
end
