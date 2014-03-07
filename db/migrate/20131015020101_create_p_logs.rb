class CreatePLogs < ActiveRecord::Migration
  def change
    create_table :program_log_entries do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
