class Legacy::Track < Legacy::OracleBase
  self.table_name = 'NEW_TRACKS'

  has_many :play_logs, primary_key: :id, foreign_key: :track_id
end
