class CreateContestSuggestions < ActiveRecord::Migration
  def change
    create_table :contest_suggestions do |t|
      t.string :name
      t.datetime :date
      t.string :venue

      t.timestamps
    end
  end
end
