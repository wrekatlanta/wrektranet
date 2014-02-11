class Legacy::PlayLog < Legacy::OracleBase
  self.table_name = 'PLAY_LOG'

  belongs_to :track
  belongs_to :staff, primary_key: :id, foreign_key: :played_by

  scope :recent, -> { order('playtime desc') }

  def user
    self.staff ||= Legacy::Staff.new(initials: 'auto')
  end
end
