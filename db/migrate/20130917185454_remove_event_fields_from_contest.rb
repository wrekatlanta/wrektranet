class RemoveEventFieldsFromContest < ActiveRecord::Migration
  def change
    remove_column :contests, :date, :datetime
    remove_column :contests, :name, :string
  end
end
