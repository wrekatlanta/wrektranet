class AddSentToContest < ActiveRecord::Migration
  def change
    add_column :contests, :sent, :boolean
  end
end
