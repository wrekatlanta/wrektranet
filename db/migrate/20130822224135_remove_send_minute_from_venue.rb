class RemoveSendMinuteFromVenue < ActiveRecord::Migration
  def change
    remove_column :venues, :send_minute, :integer
  end
end
