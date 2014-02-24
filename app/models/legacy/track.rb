# == Schema Information
#
# Table name: NEW_TRACKS
#
#  track_id        :integer          not null, primary key
#  album_id        :integer          not null
#  side            :string(1)
#  track           :string(2)
#  performance_by  :string(70)
#  track_title     :string(70)
#  minutes         :integer
#  seconds         :integer
#  format          :integer
#  in_rotation     :string(1)
#  notes           :string(40)
#  recording_year  :datetime
#  date_programmed :datetime
#

class Legacy::Track < Legacy::OracleBase
  self.table_name = 'NEW_TRACKS'

  has_many :play_logs, primary_key: :id, foreign_key: :track_id
  belongs_to :album
  belongs_to :format, foreign_key: :format

  def to_builder
    Jbuilder.new do |track|
      track.id track_id
      track.album_id album_id
      track.side side
      track.track self.track
      track.format self.format
      track.play_logs self.play_logs.recent, :playtime, :user
    end
  end
end
