class AddColumnReasonToTimeSlot < ActiveRecord::Migration
  def change
    add_column :time_slots, :reason, :string
  end
end
