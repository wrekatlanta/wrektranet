class ChangeSendTimeInVenues < ActiveRecord::Migration
  def self.up
    remove_column :venues, :send_time
    add_column :venues, :send_hour, :integer
    add_column :venues, :send_minute, :integer
  end

  def self.down
    add_column :venues, :send_time, :time
    remove_column :venues, :send_hour, :integer
    remove_column :venues, :send_minute, :integer
  end
end
