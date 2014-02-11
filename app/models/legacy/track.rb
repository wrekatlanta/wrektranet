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
