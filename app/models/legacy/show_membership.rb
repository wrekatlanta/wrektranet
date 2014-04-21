# == Schema Information
#
# Table name: show_memberships
#
#  id                :integer          not null, primary key
#  staff_id          :integer          default(0), not null
#  specialty_show_id :integer          default(0), not null
#  public_notes      :text
#  private_notes     :text
#

class Legacy::ShowMembership < Legacy::Base
  self.table_name = 'show_memberships'
  self.primary_key = 'id'

  belongs_to :staff, foreign_key: :staff_id
  belongs_to :show, foreign_key: :specialty_show_id
end
