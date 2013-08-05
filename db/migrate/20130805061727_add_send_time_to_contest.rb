class AddSendTimeToContest < ActiveRecord::Migration
  def change
    add_column :contests, :send_time, :datetime
  end
end
