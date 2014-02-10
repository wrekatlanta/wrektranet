class Legacy::Track < Legacy::OracleBase
  self.table_name = 'NEW_TRACKS'

  has_many :play_logs, primary_key: :id, foreign_key: :track_id
  belongs_to :album
  belongs_to :format, foreign_key: :format
end
