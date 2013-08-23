class AddDefaultToSentInContest < ActiveRecord::Migration
  def up
    change_column :contests, :sent, :boolean, default: false
  end

  def down
    change_column :contests, :sent, :boolean, default: nil
  end
end
