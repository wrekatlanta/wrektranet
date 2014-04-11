class AddShowToContestSuggestion < ActiveRecord::Migration
  def change
    add_column :contest_suggestions, :show, :string
  end
end
