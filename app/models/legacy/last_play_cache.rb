# == Schema Information
#
# Table name: LAST_PLAY_CACHE
#
#  track_id  :integer
#  playtime  :datetime
#  played_by :integer
#

class Legacy::LastPlayCache < Legacy::OracleBase
  self.table_name = 'LAST_PLAY_CACHE'
end
