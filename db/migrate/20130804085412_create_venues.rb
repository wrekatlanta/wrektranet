class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :fax
      t.string :address
      t.integer :send_day_offset
      t.time :send_time
      t.text :notes

      t.timestamps
    end
  end
end
