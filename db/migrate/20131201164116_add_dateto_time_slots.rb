class AddDatetoTimeSlots < ActiveRecord::Migration
  def change
    add_column :time_slots, :date, :date
  end
end
