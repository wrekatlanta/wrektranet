class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.datetime :time
      t.integer :line
      t.string :number
      t.string :shortName
      t.string :status
      t.string :fullName
      t.time :duration
      t.time :wait

      t.timestamps
    end
  end
end
