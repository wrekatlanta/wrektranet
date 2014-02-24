# == Schema Information
#
# Table name: ALBUM
#
#  album_id          :integer          not null, primary key
#  org_id            :integer          not null
#  media_type        :string(4)
#  album_title       :string(70)
#  performance_by    :string(70)
#  date_auditioned   :datetime
#  auditioned_by     :integer
#  notes             :string(40)
#  airplay_frequency :string(1)
#  program_status    :string(1)
#  recording_year    :datetime
#

class Legacy::Album < Legacy::OracleBase
  self.table_name = 'ALBUM'
  self.primary_key = 'album_id'

  belongs_to :organization, foreign_key: :org_id
  has_many :tracks
end
