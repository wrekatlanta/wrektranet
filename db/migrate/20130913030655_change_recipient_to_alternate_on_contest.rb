class ChangeRecipientToAlternateOnContest < ActiveRecord::Migration
  def change
    rename_column :contests, :recipient_id, :alternate_recipient_id
  end
end
