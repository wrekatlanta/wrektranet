class AddPriorityToShow < ActiveRecord::Migration
  def change
    add_column :shows, :priority, :integer
    remove_column :shows, :category
  end
end
