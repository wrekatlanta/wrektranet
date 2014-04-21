# == Schema Information
#
# Table name: teams
#
#  id        :integer          not null, primary key
#  name      :string(32)
#  leader_id :integer
#

class Legacy::Team < Legacy::Base
  self.table_name = 'teams'

  default_scope -> { order('name ASC') }
end
