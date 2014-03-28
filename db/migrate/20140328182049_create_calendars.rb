class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :url
      t.string :name
      t.string :default_location
      t.integer :weeks_to_show, default: 1

      t.timestamps
    end
  end
end
