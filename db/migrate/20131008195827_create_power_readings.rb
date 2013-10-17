class CreatePowerReadings < ActiveRecord::Migration
  def change
    create_table :power_readings do |t|
      t.float :plate_current
      t.float :plate_voltage
      t.float :power_out

      t.timestamps
    end
  end
end
