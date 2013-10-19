class CreateListenerLogs < ActiveRecord::Migration
  def change
    create_table :listener_logs do |t|
      t.integer :hd2_128
      t.integer :main_128
      t.integer :main_24

      t.timestamps
    end
  end
end
