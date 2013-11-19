class AddColumnUserIdToTimeSlot < ActiveRecord::Migration
  def change
    add_column :time_slots, :user_id, :integer
  end
end
