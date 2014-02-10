class Legacy::PlayLog < Legacy::OracleBase
  self.table_name = 'PLAY_LOG'

  belongs_to :track

  scope :recent, -> { order('playtime desc') }
end
