# == Schema Information
#
# Table name: team_memberships
#
#  id            :integer          not null, primary key
#  staff_id      :integer          default(0), not null
#  team_id       :integer          default(0), not null
#  public_notes  :text
#  private_notes :text
#

class Legacy::TeamMembership < Legacy::Base
  self.table_name = 'team_memberships'
  self.primary_key = 'id'

  belongs_to :staff, foreign_key: :staff_id
  belongs_to :team
end
